class Panel::BenchmarkMultiObjectsController < Panel::BaseController
  before_action :set_benchmark, only: [:edit, :update]
  before_action :benchmarks_search_params

  def index
    @form = Panel::CreateBenchmarkMultiObjectForm.new({})
    @benchmarks = BenchmarkQuery.new(@search_params.merge({benchmark_key: 'MULTI_OBJ_TEST'})).results
  end

  def create
    # http://media.vogue.com/r/h_660,w_440/2015/10/28/celebrity-style-angelina-jolie-pitt.jpg
    @form = Panel::CreateBenchmarkMultiObjectForm.new(multi_object_recog_params)

    unless @form.valid?
      render :index
      return
    end

    service = Panel::CreateBenchmarkMultiObjectService.new(@form)

    @detail = service.call
    if @detail
      redirect_to edit_panel_benchmark_multi_object_path(@detail),
                  notice: _('Successfully posting image to PRS.')
    else
      render :index
    end
  end

  def edit

  end

  private

  def set_benchmark
    @detail = ExecutionBenchmark.find(params[:id])
  end

  def multi_object_recog_params
    params.require(:multi_object_test_form).permit(:image_url, :image_file)
  end

  def benchmarks_search_params
    @search_params = params.permit(:sort, :direction, :page, :per, :review)
  end

  def sort_column
    ['benchmark_key', 'created_at', 'breakdown_1_ms',
     'breakdown_2_ms', 'breakdown_3_ms'].include?(params[:sort]) ? params[:sort] : 'created_at'
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : (sort_column == 'created_at' ? 'desc' : 'asc')
  end

end