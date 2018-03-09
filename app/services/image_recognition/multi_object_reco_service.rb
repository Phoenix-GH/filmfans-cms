require 'net/http/post/multipart'

class ImageRecognition::MultiObjectRecoService
  def initialize(current_user, image_params)
    @current_user = current_user
    @image_params = image_params

    @is_ulab_prs = (image_params[:prs] == ImageRecognition::SendImageForAnalysisService::PRS_ULAB_PARAM_VALUE) ||
        (ENV['PRS_USE_SYSTEM'] == 'ulab_multi')
    @access_key = image_params[:access_key] || ''
    @secret_key = image_params[:secret_key] || ''
  end

  def recognize(benchmark)
    @timing = {
        prs_total_time_with_network: 0,
        prs_total_execution_time: 0, # no network
        prs_single_classification_time: 0,
        prs_image_preprocessing_time_at_proxy: 0,
        prs_product_retrieval_time: 0,
        hs_product_lookup_time: 0,
        prs_multi_classification_time: 0
    }
    @image_tracking_detail = {}

    json_result = classify_multi_object(benchmark)

    @error_calling_image_recognition = false
    {
        json_result: json_result,
        timing: @timing,
        image_tracking_detail: @image_tracking_detail.merge(
            {
                error_calling_image_recognition: @error_calling_image_recognition,
                # just to be same as the single objec result
                sent_to_ma: benchmark.sent_to_ma
            })
    }
  end

  def sub_result(result_id)
    return nil if result_id.blank?

    begin
      object_crop = BenchmarkMultiObjectCrop.find_by(id: result_id)

      return sub_result_for_object(object_crop)
    rescue => e
      LogHelper::log_exception(e)
    end
    nil
  end

  def serialized_sub_results(benchmark)
    serialize_sub_results(benchmark)
  end

  private

  def classify_multi_object(benchmark)
    img_tmp_file = TempFileHelper::create_from_base64(@image_params[:image].to_s)
    img_crop_tmp_file = nil

    begin
      json_str = send_in_multipart_form(img_tmp_file)
      multi_obj_combined_json = ActiveSupport::JSON.decode(json_str)

      @timing[:prs_total_time_with_network] = @image_recognition_end2end_time
      @timing[:prs_total_execution_time] = get_timing(multi_obj_combined_json, 'execution_time') # no network
      @timing[:prs_single_classification_time] = get_timing(multi_obj_combined_json, 'single_class_time')
      @timing[:prs_image_preprocessing_time_at_proxy] = get_timing(multi_obj_combined_json, 'image_preprocessing_time_at_proxy')
      @timing[:prs_product_retrieval_time] = get_timing(multi_obj_combined_json, 'product_retrieval_time')
      @timing[:prs_multi_classification_time] = get_timing(multi_obj_combined_json, 'multi_class_time')
      @timing[:ma_time] = get_timing(multi_obj_combined_json, 'ma_time')

      boxes_with_product_result = multi_obj_combined_json['boxes']

      benchmark.sent_to_ma = multi_obj_combined_json['send_to_ma']
      benchmark.details = benchmark.details.merge(
          {
              cached_image_file_id: multi_obj_combined_json['cached_image_file_id']
          })
      benchmark.save!

      img_crop_tmp_file = save_user_crop_img_to_file(img_tmp_file)

      # {message, man, woman, selected_sub_result_id, sub_results}
      json_result = ImageRecognition::RetrieveProductFromImageService::empty_response
      json_result[:message] = multi_obj_combined_json['message'] # if any

      unless boxes_with_product_result.blank?
        selected_object = nil
        last_object = nil

        boxes_with_product_result.each do |box|
          classification = box['class_result']
          next if classification.blank?

          object_attr = {
              details: {
                  category: nil, # box category, not returned in new API
                  area: box['box'], # [x1, y1, x2, y2]
                  probability: box['box_conf'], # box confidence,
                  box_class: box['box_class'],
                  classification: {
                      confidence: classification['probability'],
                      class_name: classification['classification_results']
                  },
                  search_super_type: box['search_super_type'],
                  search_multi_categories: box['search_multi_categories'].blank? ? nil : box['search_multi_categories'].join(','),
                  # for ULAB PRS
                  cached_image_file_id: box['cached_image_file_id']
              },
              execution_benchmark: benchmark
          }

          unless classification['result'].blank? && classification['keywords'].blank?
            result_from_image = ImageRecognition::RetrieveProductFromImageService.new(@current_user,
                                                                                      nil).lookup_products(classification)
            @timing[:hs_product_lookup_time] = (result_from_image[:timing] || {})[:hs_product_lookup_time]

            if result_from_image[:json_result]
              json_result = result_from_image[:json_result]
              if result_from_image[:image_tracking_detail]
                @image_tracking_detail = {
                    classifier: result_from_image[:image_tracking_detail][:classifier],
                    classifier_probability: result_from_image[:image_tracking_detail][:classifier_probability],
                    result_message: result_from_image[:image_tracking_detail][:result_message],
                    result_keywords: result_from_image[:image_tracking_detail][:result_keywords]
                }
              end
            end

            object_attr[:details].merge!(
                {
                    image_tracking_detail: result_from_image[:image_tracking_detail],
                    json_result: json_result
                })
          end

          object = BenchmarkMultiObjectCrop.create(object_attr)
          # must crop the box a store it to S3 synchronously here because we need to display it on the app
          object.image = img_crop_tmp_file
          object.save!
          last_object = object
          unless classification['result'].blank?
            selected_object = object
          end
        end

        selected_object = last_object if selected_object.nil?
        benchmark = benchmark.reload
        json_result = json_result.merge(
            {
                selected_sub_result_id: selected_object.id,
                sub_results: serialize_sub_results(benchmark)
            })
        selected_object.details = selected_object.details.merge(
            {
                json_result: json_result
            })
        selected_object.save!
      end

      return json_result
    rescue => e
      @error_calling_image_recognition = true
      LogHelper::log_exception(e)
    ensure
      TempFileHelper::delete_quite(img_tmp_file)
      TempFileHelper::delete_quite(img_crop_tmp_file)
    end
    false
  end

  def save_user_crop_img_to_file(origin_tmp_file)
    image_crop = user_crop_area
    ImageHelper.crop_image_from_file(origin_tmp_file, image_crop[:x], image_crop[:y], image_crop[:width], image_crop[:height])
  end

  def send_in_multipart_form(img_tmp_file)
    @proxy_uri = URI.parse("#{ENV['PRS_ULAB_PROXY_URL']}/proxy/multi_obj_reco")
    if @is_ulab_prs
      @proxy_uri = URI.parse("#{ENV['PRS_ULAB_URL']}/api/multi-obj-reco")
    end

    response = nil
    @image_recognition_end2end_time = Benchmark.realtime {
      #:read_timeout => 60 (default 60 seconds)
      response = Net::HTTP.start(@proxy_uri.host, @proxy_uri.port) do |http|
        http.request(request_parameters(img_tmp_file))
      end
    }
    return response&.body
  end

  def request_parameters(img_tmp_file)
    image_crop = user_crop_area

    params = {
        'date' => Time.now.to_i,
        'crop' => "#{image_crop[:x]},#{image_crop[:y]},#{image_crop[:width]},#{image_crop[:height]}",
        'image_upload' => UploadIO.new(img_tmp_file, "image/jpg", "my_picture.jpg"),
        'limit' => ImageRecognition::SnapProductsFromJsonService.number_of_prs_result_products
    }
    if @is_ulab_prs
      params = params.merge({'access_key' => @access_key, 'secret_key' => @secret_key})
    end

    Rails.logger.info "Calling #{@proxy_uri}"
    Net::HTTP::Post::Multipart.new(
        @proxy_uri.path,
        params
    )
  end

  def user_crop_area
    image_crop = @image_params[:image_parameters]

    x = nil
    y = nil
    width = nil
    height = nil
    unless image_crop.blank?
      x = image_crop[:x].to_i.abs
      y = image_crop[:y].to_i.abs
      width = image_crop[:width].to_i.abs
      height = image_crop[:height].to_i.abs
    end
    {x: x, y: y, width: width, height: height}
  end

  def sub_result_for_object(object)
    if object.nil? || object.image_url.blank?
      return nil
    end

    # already fetched
    unless object.json_result.blank?
      return object.json_result
    end

    benchmark = object.execution_benchmark
    img_url = benchmark.image.cropped_url

    Rails.logger.info "PRS: getting products for object #{object.id} box #{object.area_as_xywh} of #{img_url}"
    parameters = {
        image_url: img_url,
        classification: object.classification,
        probability: object.classification_confidence,
        search_super_type: object.search_super_type,
        search_multi_categories: object.search_multi_categories,
        cached_image_file_id: benchmark.details['cached_image_file_id'] || object.details['cached_image_file_id'],
        image_parameters: object.area_as_xywh,
        prs: @image_params[:prs],
        v: @image_params[:v],
        access_key: @access_key,
        secret_key: @secret_key
    }
    result_from_image = ImageRecognition::RetrieveProductFromImageService.new(@current_user, parameters).retrieve

    json_result = result_from_image[:json_result]
    if json_result
      json_result = json_result.merge(
          {
              selected_sub_result_id: object.id,
              sub_results: serialize_sub_results(benchmark)
          })
    end

    object.details = object.details.merge({image_tracking_detail: result_from_image[:image_tracking_detail]})
    object.details = object.details.merge({json_result: json_result})
    object.save!

    json_result
  end

  def empty_timing
    {
        image_recognition_end2end_time: 0,
        hs_product_lookup_time: 0,
        image_search_only_time: 0,
        image_multi_object_time: 0
    }
  end

  def serialize_sub_results(benchmark)
    user_box_top = {x: 0, y: 0}
    unless benchmark.details['image_parameters'].blank?
      user_box_top[:x] = benchmark.details['image_parameters']['x']&.to_i || 0
      user_box_top[:y] = benchmark.details['image_parameters']['y']&.to_i || 0
    end

    sub_results = benchmark.ordered_crops.map { |obj_crop|
      box = box_for_app(user_box_top, obj_crop)
      {
          id: obj_crop.id,
          name: product_category_name(obj_crop),
          crop_img: obj_crop.image_url,
          box: box
      }
    }

    calculate_box_anchor(sub_results)

    sub_results
  end

  def product_category_name(obj_crop)
    unless obj_crop.classification.blank?
      cat = Category.where(imaging_category: obj_crop.classification).first
      unless cat.nil?
        return cat.name
      end

      Rails.logger.info "Cannot find corresponding category for classifier: #{obj_crop.classification}"
    end

    # BAD! strange category name returned by PRS
    tech_name = obj_crop.box_category || obj_crop.classification
    tech_name
        &.gsub(/^(man_|woman_)/, '')
        &.gsub(/\_/, ' ')
        &.capitalize
  end

  def get_timing(prs_json, key)
    return 0 if prs_json.blank?
    prs_json[key] || 0
  end

  def box_for_app(user_box_top, obj_crop)
    box = obj_crop.area_as_xywh

    # transform to original image coordinate
    box[:x] = (box[:x] + user_box_top[:x]).to_i
    box[:y] = (box[:y] + user_box_top[:y]).to_i

    # safer for the apps
    box[:width] -= 1
    box[:height] -= 1
    box
  end

  def calculate_box_anchor(sub_results)
    sub_results.each { |sub|
      box = sub[:box]
      unless box.blank?
        sub[:anchor] = {
            x: box[:x] + (box[:width] / 2).to_i,
            y: box[:y] + (box[:height] / 2).to_i
        }
      end
    }

    # assumption on the anchor's radiation
    radiation = 17

    # detect overlapped anchors
    for i in 0..sub_results.size - 1
      overlapped_each_others = [sub_results[i]]

      for j in i + 1 .. sub_results.size - 1
        if overlapped_circle?(sub_results[i][:anchor], sub_results[j][:anchor], radiation)
          overlapped_each_others << sub_results[j]
        end
      end

      strategies = %w(ce tl tr bl br mt mr mb ml)
      if overlapped_each_others.size > 1
        # for debugging
        Rails.logger.info "Overlapped boxes: #{overlapped_each_others.map { |sub| {anchor: sub[:anchor], id: sub[:id], box: sub[:box]} }}"

        overlapped_each_others.each_with_index { |sub, index|
          if strategies.size > index
            case strategies[index]
              when 'tl'
                sub[:anchor] = {x: sub[:box][:x] + radiation, y: sub[:box][:y] + radiation}
              when 'tr'
                sub[:anchor] = {x: sub[:box][:x] + sub[:box][:width] - radiation, y: sub[:box][:y] + radiation}
              when 'bl'
                sub[:anchor] = {x: sub[:box][:x] + radiation, y: sub[:box][:y] + sub[:box][:height] - radiation}
              when 'br'
                sub[:anchor] = {x: sub[:box][:x] + sub[:box][:width] - radiation, y: sub[:box][:y] + sub[:box][:height] - radiation}
              when 'ce' # center
                # it's the default mode
              when 'mt' # middle top
                sub[:anchor] = {x: sub[:box][:x] + (sub[:box][:width] / 2).to_i, y: sub[:box][:y] + radiation}
              when 'mr'
                sub[:anchor] = {x: sub[:box][:x] - radiation, y: sub[:box][:y] + (sub[:box][:height] / 2).to_i}
              when 'mb'
                sub[:anchor] = {x: sub[:box][:x] + (sub[:box][:width] / 2).to_i, y: sub[:box][:y] - radiation}
              when 'ml'
                sub[:anchor] = {x: sub[:box][:x] + radiation, y: sub[:box][:y] + (sub[:box][:height] / 2).to_i}
              else
                Rails.logger.warn "unknown overlapped anchor strategy: #{strategies[index]}"
            end
          else
            Rails.logger.warn "More than #{strategies.size} overlapped boxes!"
          end
        }
      end
    end
  end

  def overlapped_circle?(point_1, point_2, radiation)
    return false if point_1.blank? || point_2.blank?

    bound_1 = circle_to_bound(point_1, radiation)
    bound_2 = circle_to_bound(point_2, radiation)

    left = [bound_1[:x1], bound_2[:x1]].max
    right = [bound_1[:x2], bound_2[:x2]].min

    top = [bound_1[:y1], bound_2[:y1]].max
    bottom = [bound_1[:y2], bound_2[:y2]].min
    right > left && bottom > top
  end

  def circle_to_bound(point, radiation)
    {
        x1: point[:x] - radiation,
        y1: point[:y] - radiation,
        x2: point[:x] + radiation,
        y2: point[:y] + radiation
    }
  end
end