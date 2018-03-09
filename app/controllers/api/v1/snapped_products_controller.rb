class Api::V1::SnappedProductsController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!, only: [:index]

  def index
    products = current_api_v1_user.photographed_products

    render json: products.map { |product|
      ProductSerializer.new(product, with_similar_products: false).results
    }
  end

  def capture
    total_elapsed_time = Benchmark.realtime {
      begin
        image_params[:image] = compress_image(image_params[:image]) unless image_params[:no_img_compression]

        @benchmark = new_empty_benchmark

        # store the query image to S3 while sending it to GPU server
        SaveBenchmarkImageWorker.perform_async(@benchmark.id, image_params)

        capture_in_measurement
      rescue => e
        LogHelper::log_exception(e)
        empty_result
      end
    }

    if capturing_sub_benchmark? && @image_timing.blank? || @image_tracking_detail.blank?
      @benchmark.delete unless @benchmark.blank?
      return
    end

    begin
      image_recognition_time = (@image_timing[:prs_total_time_with_network] || 0) * 1000
      hs_product_lookup_time = (@image_timing[:hs_product_lookup_time] || 0) * 1000
      prs_total_execution_time = (@image_timing[:prs_total_execution_time] || 0)

      total_elapsed_time = total_elapsed_time * 1000
      hs_time = total_elapsed_time - image_recognition_time

      if @benchmark
        @benchmark.sent_to_ma = @image_tracking_detail[:sent_to_ma]
        @benchmark.save

        if capturing_sub_benchmark?
          main_benchmark = ExecutionBenchmark.find(image_params[:from_benchmark_id])
          main_benchmark.sub_benchmark_id = @benchmark.id
          main_benchmark.save!
        end
      end

      SaveBenchmarkWorker.perform_async(
          @benchmark.nil? ? nil : @benchmark.id,
          {
              benchmark_key: 'CROP_AND_SHOP',
              execution_ms: total_elapsed_time,
              breakdown_1_ms: hs_time,
              breakdown_2_ms: image_recognition_time,
              breakdown_3_ms: hs_product_lookup_time,
              breakdown_4_ms: prs_total_execution_time,
              details: {
                  total_time: total_elapsed_time,
                  hs_time: hs_time,
                  hs_product_lookup_time: hs_product_lookup_time,
                  image_recognition_time: image_recognition_time, # include network time
                  image_search_only_time: prs_total_execution_time,
                  prs_image_preprocessing_time_at_proxy: @image_timing[:prs_image_preprocessing_time_at_proxy],
                  prs_product_retrieval_time: @image_timing[:prs_product_retrieval_time],
                  prs_single_classification_time: @image_timing[:prs_single_classification_time],
                  prs_multi_classification_time: @image_timing[:prs_multi_classification_time],
                  ma_time: @image_timing[:ma_time],

                  remote_ip: capturing_sub_benchmark? ? nil : request.remote_ip,
                  image_parameters: image_params[:image_parameters],

                  # only for single-object
                  search_categories: @image_tracking_detail['search_categories'],
                  classifier: @image_tracking_detail[:classifier],
                  classifier_probability: @image_tracking_detail[:classifier_probability],
                  error_calling_image_recognition: @image_tracking_detail[:error_calling_image_recognition],
                  result_pids: @image_tracking_detail[:result_pids],
                  prs_result_pids: @image_tracking_detail[:prs_result_pids],
                  result_message: @image_tracking_detail[:result_message],
                  result_keywords: @image_tracking_detail[:result_keywords],

                  v: image_params[:v],
                  prs: image_params[:prs],
                  access_key: image_params[:access_key],
                  secret_key: image_params[:secret_key],

                  prs_name: get_prs,
                  app_name: image_params[:app_name],
                  app_version: image_params[:app_version],
                  phone_type: image_params[:phone_type],
                  phone_os: image_params[:phone_os]
              }
          },
          image_params)
    rescue => e
      LogHelper::log_exception(e)
    end
  end

  def sub_results
    result = ImageRecognition::MultiObjectRecoService.new(current_api_v1_user, sub_results_params).sub_result(sub_results_params[:id])
    if result.blank?
      empty_result
    else
      render json: result.merge({call_id: "sub_#{sub_results_params[:id]}"})
    end
  end

  def feedback
    benchmark = ExecutionBenchmark.find(feedback_params[:call_id])
    unless benchmark.blank?
      like = feedback_params[:like]
      like = !!like == like ? like : nil
      benchmark.like = like
      benchmark.user_comment = feedback_params[:comment]
      benchmark.save
    end

    render json: {
        success: true,
        message: 'Thank you. Your feedback improved the system!'
    }
  end

  def capture_from_benchmark(from_benchmark_id)
    return if from_benchmark_id.blank?

    from_benchmark = ExecutionBenchmark.find(from_benchmark_id)
    rebuild_capture_params(from_benchmark)

    capture
  end

  private

  def capture_in_measurement
    encoded_image = image_params[:image].to_s

    if get_current_crop_shop_user.present? && image_to_save
      SaveSnappedPhotoWorker.perform_async(get_current_crop_shop_user.id, encoded_image)
    end

    if is_multi_object_reco?
      multi_object_reco
    else
      single_object_reco
    end
  end

  def single_object_reco
    result = ImageRecognition::RetrieveProductFromImageService.new(get_current_crop_shop_user, image_params).retrieve

    @image_tracking_detail = result[:image_tracking_detail] || {}
    @image_timing = result[:timing] || {}

    unless capturing_sub_benchmark?
      if result[:json_result]
        render json: hack_json_result(result[:json_result].merge({call_id: @benchmark.id}))
      else
        empty_result
      end
    end
  end

  # iOS app crash without sub-result attribute
  def hack_json_result json
    if json[:selected_sub_result_id].blank?
      json = json.merge({selected_sub_result_id: 0})
    end
    if json[:sub_results].blank?
      json = json.merge({
                            sub_results: [{
                                              id: 0,
                                              name: 'All',
                                              crop_img: 'https://s3-ap-southeast-1.amazonaws.com/media-production-hotspotting/uploads/crop_and_shop/all.png'
                                          }]
                        })
    end
    json
  end

  def multi_object_reco
    result = ImageRecognition::MultiObjectRecoService.new(get_current_crop_shop_user, image_params).recognize(@benchmark)
    @image_tracking_detail = result[:image_tracking_detail] || {}
    @image_timing = result[:timing] || {}

    unless capturing_sub_benchmark?
      if result[:json_result]
        render json: hack_json_result(result[:json_result].merge({call_id: @benchmark.id}))
      else
        empty_result
      end
    end
  end

  def empty_result
    unless capturing_sub_benchmark?
      Rails.logger.info 'Sent empty response, likely error happened'
      render json: hack_json_result(ImageRecognition::RetrieveProductFromImageService::empty_response)
    end
  end

  def new_empty_benchmark
    benchmark = ExecutionBenchmark.new

    benchmark.benchmark_key = 'CROP_AND_SHOP'
    benchmark.execution_ms = 0
    benchmark.breakdown_2_ms = 0
    benchmark.details = {
        image_parameters: image_params[:image_parameters]
    }
    benchmark.main = capturing_sub_benchmark? ? false : true

    benchmark.save!
    benchmark
  end

  def compress_image(base64Image)
    return base64Image if base64Image.blank?
    if ENV['PRS_IMAGE_COMPRESSION_LEVEL'].blank? || ENV['PRS_IMAGE_COMPRESSION_LEVEL'].to_f <= 0
      return base64Image
    end

    img = MiniMagick::Image.read(Base64.decode64(base64Image))
    img.combine_options do |c|
      c.quality(ENV['PRS_IMAGE_COMPRESSION_LEVEL'].to_f)
      c.depth "8"
      c.interlace "plane"
    end

    new_base64 = Base64.encode64(img.to_blob)
    TempFileHelper::delete_quite(img.tempfile)
    img = nil

    new_base64
  end

  def sub_results_params
    return @sub_result_params unless @sub_result_params.blank?

    @sub_result_params = params.permit(:id, :v, :prs, :access_key, :secret_key)
    # maybe getting from benchmark page
    if @sub_result_params[:v].blank? &&
        @sub_result_params[:prs].blank? &&
        @sub_result_params[:access_key].blank? &&
        @sub_result_params[:secret_key].blank?
      crop = BenchmarkMultiObjectCrop.find_by(id: @sub_result_params[:id])
      unless crop.blank?
        benchmark = crop.execution_benchmark
        if benchmark.using_ulab_prs?
          @sub_result_params = @sub_result_params.merge(
              {
                  v: benchmark.details['v'] || (is_default_multi_object_reco? ? '2' : nil),
                  prs: benchmark.details['prs'] || 'ulab',
                  access_key: benchmark.details['access_key'],
                  secret_key: benchmark.details['secret_key'],
              })
        end
      end
    end

    @sub_result_params
  end

  def image_params
    return @request_params unless @request_params.blank?

    @request_params = params.permit(:image, :do_not_save, :v, :prs, :access_key, :secret_key,
                                          # statistic params
                                          :app_name,
                                          :app_version,
                                          :phone_type,
                                          :phone_os,
                                          :lat,
                                          :long,
                                          :phone_uuid,
                                          :user_id,

                                          image_parameters: [:x, :y, :height, :width])

    if params[:phone_type].blank?
      user_agent = UserAgent.parse(request.user_agent)
      unless user_agent.platform.blank?
        @request_params.merge!(
            {
                phone_type: 'Web',
                phone_os: user_agent.platform,
                phone_uuid: user_agent.browser
            })
      end
    end

    if @request_params[:app_name] == ENV['KACHING_CROP_SHOP_APP_NAME']
      @request_params[:v] = '2'
      @request_params[:prs] = 'ulab'
    end

    @request_params
  end

  def rebuild_capture_params(from_benchmark)
    crop = from_benchmark[:details]['image_parameters']
    call_bb = from_benchmark.using_ulab_prs? # call other system

    ulab_v = nil
    unless call_bb
      ulab_v = from_benchmark.details['v'] || (is_default_multi_object_reco? ? '2' : nil)
    end

    @request_params = {
        image: Base64ImageHelper::read_from_url_as_base64(from_benchmark.image.full_url),
        do_not_save: true,

        v: ulab_v,
        prs: call_bb ? nil : 'ulab',
        access_key: nil,
        secret_key: nil,

        image_parameters: crop.blank? ? nil : {x: crop['x'], y: crop['y'], width: crop['width'], height: crop['height']},

        no_img_compression: true,
        from_benchmark_id: from_benchmark.id
    }
  end

  def get_current_crop_shop_user
    capturing_sub_benchmark? ? nil : current_api_v1_user
  end

  def capturing_sub_benchmark?
    !@request_params.blank? && !@request_params[:from_benchmark_id].blank?
  end

  def image_to_save
    image_params[:do_not_save] != 'true'
  end

  def is_multi_object_reco?
    request_multi = image_params[:v]&.to_s == '2'
    request_ulab_prs = image_params[:prs] == ImageRecognition::SendImageForAnalysisService::PRS_ULAB_PARAM_VALUE

    # backward compatibility, before having multi-object recog, apps explicitly requests ulab single object recog using prs=ulab param
    return false if request_ulab_prs && !request_multi

    (is_default_multi_object_reco? || request_multi)
  end

  def is_default_multi_object_reco?
    ((ENV['PRS_USE_SYSTEM'] == 'bb_multi') || (ENV['PRS_USE_SYSTEM'] == 'ulab_multi'))
  end

  def get_prs
    if ImageRecognition::SendImageForAnalysisService::is_using_ulab_prs?(image_params)
      'ULAB'
    else
      'BB'
    end
  end

  def feedback_params
    params.permit(:call_id, :like, :comment)
  end
end
