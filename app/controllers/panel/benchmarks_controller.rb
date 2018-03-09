class Panel::BenchmarksController < Panel::BaseController
  before_action :set_review_results, only: [:index]
  before_action :benchmarks_search_params, :benchmarks_crop_params
  before_action :set_benchmark, only: [:edit, :update]
  before_action :set_judgement_benchmark, only: [:judge]

  def index
    @benchmarks = BenchmarkQuery.new(@search_params).results
    @likes = ExecutionBenchmark.likes.count
    @dislikes = ExecutionBenchmark.dislikes.count
  end

  def edit
    if !@is_multi_crops or @crop.blank?
      # Single crop
      @form = Panel::UpdateBenchmarkForm.new(benchmark_attributes)
    else
      # Multi crop
      @form = Panel::UpdateBenchmarkForm.new(crop_attributes)
    end

    # Get image keywords of cropped
    @cropped_image_url = @cropped[:image_url]

    unless @crop.blank?
      # Get image keywords of box
      @box_image_url = @crop.try(:image).try(:url)
    end
  end

  def update
    if !@is_multi_crops or @crop.blank?
      # Single crop
      @form = Panel::UpdateBenchmarkForm.new(benchmark_attributes, benchmark_params)
      service = Panel::UpdateBenchmarkService.new(@benchmark, @form)
    else
      # Multi crops
      @form = Panel::UpdateBenchmarkForm.new(crop_attributes, benchmark_params)
      service = Panel::UpdateBenchmarkMultiObjectService.new(@crop, @form)
    end

    if service.call
      redirect_to panel_benchmarks_path(@search_params)
    else
      render :edit
    end
  end

  def edit_thresholds
    RestClient.get("#{ENV['PRS_ULAB_PROXY_URL']}/ma/thresholds") { |res|
      case res.code
        when 200
          @thresholds = JSON.parse(res.body)
        else
          @error = true
          flash[:alert] = _('Failed get thresholds!')
      end
    }
  end

  def judge
    if judge_params[:judgement].blank?
      @benchmark.update_attributes({judgement: judge_params[:judgement], judge_user: nil})
    else
      @benchmark.update_attributes({judgement: judge_params[:judgement], judge_user: current_user.email})
    end
    @benchmark.save

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  private

  def set_categories
  end

  def set_benchmark
    @assessments = [
        ['OK (correct classification & correct results)', 'PRS_OK'],
        ['Wrong category', 'PRS_W_CATE'],
        ['Irrelevant products (correct classification BUT no result, wrong results, wrong color...)', 'PRS_W_PROD'],
        ['Bad image (Bad quality, non-fashion)', 'PRS_BAD_IMG']
    ]
    @trained_categories = Category.list_display_categories(true)

    @benchmark = ExecutionBenchmark.find(params[:id])
    @is_multi_crops = @benchmark.benchmark_multi_object_crops.count > 0
    @origin = {
        file_size: @benchmark.image_file_size_pretty,
        dimension: @benchmark.origin_image_dimension,
        image_url: @benchmark.try(:image).try(:full_url)
    }

    @cropped = {
        file_size: @benchmark.cropped_file_size_pretty,
        dimension: @benchmark.crop_area,
        image_url: @benchmark.try(:image).try(:cropped_url)
    }

    @selected_area = {}

    classifier = ''
    search_categories = ''
    response_message = ''
    response_keywords = ''
    pids = prs_pids = []

    if @is_multi_crops
      # Multi crop & shop
      @recognized_areas = @benchmark.benchmark_multi_object_crops
      @is_area_selected = !@crop_params[:crop_id].blank?

      if @is_area_selected
        @search_params = @search_params.merge(crop_id: @crop_params[:crop_id])
        # Pick one of the recognized area
        @crop = @recognized_areas.where(id: @crop_params[:crop_id]).first

        unless @crop.blank?
          @selected_area = {
              id: @crop.blank? ? nil : @crop.id,
              index: @recognized_areas.each_index.select{|i| @recognized_areas[i].id.to_s == @crop_params[:crop_id]}.first
          }

          @using_ulab_prs = @crop.using_ulab_prs?
          retrained_category = @crop.retrained_category

          unless @crop.tracking_detail.blank?
            classifier = @crop.tracking_detail['classifier']
            search_categories = @crop.tracking_detail['search_categories']
            response_message = @crop.response_message
            response_keywords = @crop.response_keywords
            pids = @crop.tracking_detail['result_pids'] || []
            prs_pids = @crop.tracking_detail['prs_result_pids'] || []
          end
        end
      end
    else
      @using_ulab_prs = @benchmark.using_ulab_prs?
      retrained_category = @benchmark.retrained_category

      # Single crop & shop
      classifier = @benchmark.details['classifier']
      search_categories = @benchmark.details['search_categories']
      response_message = @benchmark.response_message
      response_keywords = @benchmark.response_keywords
      pids = @benchmark.details['result_pids'] || []
      prs_pids = @benchmark.details['prs_result_pids'] || []
    end

    @predicted_categories = []
    unless classifier.blank?
      @predicted_categories = Category.where(imaging_category: classifier).map { |c| c.full_name }
    end
    @search_categories = search_categories
    @response_message = response_message
    @response_keywords = response_keywords

    @pids = pids
    @prs_pids = prs_pids
    @products = @pids.map { |id| Product.find_by(id: id) }.compact
    @prs_products = @prs_pids.map { |id| Product.find_by(id: id) }.compact

    @retrained_category = nil
    unless @benchmark.retrained_category.blank?
      @retrained_category = Category.where(imaging_category: retrained_category).first
    end

    @sub_results = ImageRecognition::MultiObjectRecoService.new(nil, {}).serialized_sub_results(@benchmark)
  end

  def set_judgement_benchmark
    @benchmark = ExecutionBenchmark.find(params[:id])
  end

  def set_review_results
    @review_results = [
        OpenStruct.new({key: 'PRS_OK', name: 'OK'}),
        OpenStruct.new({key: 'PRS_W_CATE', name: 'Wrong category'}),
        OpenStruct.new({key: 'PRS_W_PROD', name: 'Irrelevant products'}),
        OpenStruct.new({key: 'PRS_BAD_IMG', name: 'Bad image'}),
        OpenStruct.new({key: 'NA', name: 'Not yet reviewed'}),
    ]
  end

  def benchmark_attributes
    @benchmark.slice('review', 'retrained_category', 'comment')
  end

  def crop_attributes
    return {} if @crop.blank?
    @crop.slice('review', 'retrained_category', 'comment')
  end

  def benchmark_params
    params.require(:benchmark_form).permit(:review, :retrained_category, :comment)
  end

  def benchmarks_search_params
    @search_params = params.permit(:sort, :direction, :page, :per, :review, :sent_to_ma, :like)
  end

  def benchmarks_crop_params
    @crop_params = params.permit(:crop_id)
  end

  def sort_column
    ['benchmark_key', 'created_at', 'breakdown_1_ms',
     'breakdown_2_ms', 'breakdown_3_ms'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : (sort_column == 'created_at' ? 'desc' : 'asc')
  end

  def thresholds_params
    params.permit(thresholds: params[:thresholds].keys)
  end

  def judge_params
    params.permit(:judgement)
  end
end