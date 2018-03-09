class Panel::CreateBenchmarkMultiObjectService

  def initialize(form, user_crop = nil)
    @form = form
    @user_crop = user_crop
  end

  def call
    @error_calling_image_recognition = false
    @prs_multi_obj_reco_time = 0
    @prs_classification_time = 0

    return false unless @form.valid?

    execution_time = Benchmark.realtime {
      create

      Rails.logger.info "PRS: croped #{@benchmark.image.cropped_url}"
      Rails.logger.info "PRS: origin #{@benchmark.image.full_url}"

      submit_image_to_prs(@form.image_url.blank? ? @benchmark.image.cropped_url : @form.image_url)

      update

      create_cropped_objects(@json)
    }

    if @benchmark
      # total
      @benchmark.execution_ms = (execution_time || 0) * 1000
      @benchmark.breakdown_2_ms = (total_prs_time || 0) * 1000
      # HS
      @benchmark.breakdown_1_ms = @benchmark.execution_ms - @benchmark.breakdown_2_ms
      @benchmark.details = @benchmark.details.merge(
          {
              prs_multi_obj_reco_time: (@prs_multi_obj_reco_time || 0) * 1000,
              prs_classification_time: (@prs_classification_time || 0) * 1000
          }
      )
      @benchmark.save!
    end

    @benchmark
  end

  def error_calling_image_recognition?
    @error_calling_image_recognition
  end

  def total_prs_time
    @prs_multi_obj_reco_time + @prs_classification_time
  end

  private

  def create
    @benchmark = ExecutionBenchmark.new

    @benchmark.benchmark_key = 'MULTI_OBJ_TEST'
    @benchmark.execution_ms = 0
    @benchmark.breakdown_2_ms = 0
    @benchmark.details = {image_parameters: @user_crop}

    @benchmark.image = @form.image_file
    @benchmark.remote_image_url = @form.image_url
    @benchmark.save!
    @benchmark
  end

  def update
    return unless @json
    @benchmark.details = @benchmark.details.merge({multi_objects: @json})
    @benchmark.save!
  end

  def submit_image_to_prs(img_url)
    @img_url_sent_multiobj = img_url
    prefix = "#{ENV['PRS_MULTI_OBJ_CLASSIFIER_URL']}?im_url="
    call_url = "#{prefix}#{URI::encode(@img_url_sent_multiobj)}"
    Rails.logger.info "PRS: call to multiobj #{call_url}"

    @prs_multi_obj_reco_time = Benchmark.realtime {
      RestClient.post(call_url, {}.to_json, {content_type: 'text/html; charset=utf-8', accept: :json}) { |response, request, result, &block|
        case response.code
          when 200
            @json = JSON.parse(response.body)
          else
            @error_calling_image_recognition = true
            Rails.logger.error response
        end
      }
    }
  end


  def create_cropped_objects(json)
    return unless json.present?

    cropped_file = TempFileHelper::create_from_url(@img_url_sent_multiobj)
    begin
      save_objects_with_classification(json, cropped_file)
    ensure
      TempFileHelper::delete_quite(cropped_file)
    end

    @benchmark = @benchmark.reload
  end

  def save_objects_with_classification(json, cropped_file)
    # {
    #     "box" : [
    #         161.08602905273438,
    #         189.2717742919922,
    #         312.7493591308594,
    #         581.2935180664062
    #     ],
    #     "box_conf" : 0.5959149599075317,
    #     "box_class" : "woman_skirt",
    # }

    json.each do |obj_json|
      area = obj_json['box']
      next if area.size < 4

      box_confidence = obj_json['box_conf']

      object = BenchmarkMultiObjectCrop.new
      object.details = {
          category: obj_json['box_class'], # box category
          area: area,
          probability: box_confidence, # box confidence
          classification_time: nil, # not returned separately
          error_calling_image_recognition: false

      }
      object.execution_benchmark = @benchmark
      object.image = cropped_file
      object.save!

    end
  end

end