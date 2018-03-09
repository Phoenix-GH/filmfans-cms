require 'net/http/post/multipart'

class ImageRecognition::SendImageForAnalysisService

  PRS_ULAB_PARAM_VALUE = 'ulab'

  def initialize(image_params)
    @image_url = image_params[:image_url]
    @encoded_image = image_params[:image]
    @image_crop = image_params[:image_parameters] || {}
    @classification = image_params[:classification]
    @probability = image_params[:probability] || ''
    @cached_image_file_id = image_params[:cached_image_file_id]
    @search_super_type = image_params[:search_super_type]
    @search_multi_categories = image_params[:search_multi_categories]

    @timestamp = Time.now.to_i
    @nonce = SecureRandom.hex(15)
    @is_ulab_prs = ImageRecognition::SendImageForAnalysisService::is_using_ulab_prs?(image_params)
    @access_key = image_params[:access_key] || ''
    @secret_key = image_params[:secret_key] || ''
  end

  def self.is_using_ulab_prs?(image_params)
    (image_params[:prs] == ImageRecognition::SendImageForAnalysisService::PRS_ULAB_PARAM_VALUE) ||
        (image_params['prs'] == ImageRecognition::SendImageForAnalysisService::PRS_ULAB_PARAM_VALUE) ||
        (ENV['PRS_USE_SYSTEM'] == 'ulab_single') || (ENV['PRS_USE_SYSTEM'] == 'ulab_multi')
  end

  def call
    if @is_ulab_prs
      if @image_url.blank?
        Rails.logger.info 'Image binary submitted, the image will be sent to single object recog path'
        submit_to_single_object_recog
      else
        retrieve_product_with_classification
      end
    else
      if @classification.blank?
        Rails.logger.info 'No classification given, the image will be sent to single object recog path'
        submit_to_single_object_recog
      elsif @image_url.blank?
        Rails.logger.info 'Image binary submitted, the image will be sent to single object recog path'
        submit_to_single_object_recog
      else
        retrieve_product_with_classification
      end
    end
  end

  def image_crop
    x = @image_crop[:x].to_i.abs
    y = @image_crop[:y].to_i.abs
    width = @image_crop[:width].to_i.abs
    height = @image_crop[:height].to_i.abs

    "#{x},#{y},#{width},#{height}"
  end

  def image_recognition_elapsed_time
    @image_recognition_elapsed
  end

  private

  def retrieve_product_with_classification
    return false if @image_url.blank? || (!@is_ulab_prs && @classification.blank?)

    prefix = "#{ENV['PRS_ULAB_PROXY_URL']}/proxy/single_obj_reco?category=#{@classification}&probability=#{@probability}&im_url="
    if @is_ulab_prs
      prefix = "#{ENV['PRS_ULAB_URL']}/api/search-image?im_url="
    end
    call_url = "#{prefix}#{URI::encode(@image_url)}"
    Rails.logger.info "PRS: retrieve products: #{call_url}"

    params = {
        cached_image_file_id: @cached_image_file_id,
        search_super_type: @search_super_type,
        search_multi_categories: @search_multi_categories,
        crop: image_crop,
        limit: ImageRecognition::SnapProductsFromJsonService.number_of_prs_result_products,
        multipart: true
    }
    if @is_ulab_prs
      params = params.merge({'access_key' => @access_key, 'secret_key' => @secret_key})
    end

    begin
      json_body = false
      @image_recognition_elapsed = Benchmark.realtime {
        RestClient.post(call_url,
                        params,
                        {accept: :json}) { |response, request, result, &block|
          case response.code
            when 200
              json_body = response.body
            else
              Rails.logger.error response
          end
        }
      }
      return json_body
    rescue => e
      LogHelper::log_exception(e)
      return false
    end
  end

  def submit_to_single_object_recog
    begin
      if @is_ulab_prs
        @uri = URI.parse("#{ENV['PRS_ULAB_URL']}/api/search-image")
      else
        @uri = URI.parse("#{ENV['PRS_ULAB_PROXY_URL']}/proxy/single_obj_reco")
      end

      if @encoded_image.blank?
        @temp_file = TempFileHelper::create_from_url(@image_url)
      else
        @temp_file = TempFileHelper::create_from_base64(@encoded_image)
      end

      if send_in_multipart_form
        return @response.body
      else
        return false
      end

    rescue => e
      LogHelper::log_exception(e)
      return false
    ensure
      TempFileHelper.delete_quite(@temp_file)
    end
  end

  def send_in_multipart_form
    @image_recognition_elapsed = Benchmark.realtime {
      #:read_timeout => 60 (default 60 seconds)
      @response = Net::HTTP.start(@uri.host, @uri.port) do |http|
        http.request(request_parameters)
      end
    }
    return false unless @response && @response.body

    true
  end

  def request_parameters
    params = {
        'api_sig' => api_signature,
        'api_key' => ENV['IMAGE_METRY_API_KEY'],
        'date' => @timestamp,
        'nonce' => @nonce,
        'method' => "object_recognition",
        'crop' => image_crop,
        'limit' => ImageRecognition::SnapProductsFromJsonService.number_of_prs_result_products,
        'image_upload[]' => UploadIO.new(@temp_file, "image/jpg", "my_picture.jpg")
    }

    if @is_ulab_prs
      params = params.merge({'access_key' => @access_key, 'secret_key' => @secret_key})
    end

    Rails.logger.info "Calling #{@uri}"

    Net::HTTP::Post::Multipart.new(
      @uri.path,
      params
    )
  end

  def api_signature
    Digest::SHA1.hexdigest(
      "#{ENV['IMAGE_METRY_API_PRIVATE_KEY']}"\
      "#{ENV['IMAGE_METRY_API_SECRET']}"\
      "#{@timestamp}"\
      "#{@nonce}"\
      "my_picture.jpg"
    )
  end
end
