class SaveBenchmarkWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'benchmark'

  def perform(benchmark_id, new_benchmark_obj, image_params)
    @image_params = {
        do_not_save: image_params['do_no_save'],
        v: image_params['v'],
        image: image_params['image'],
        image_url: image_params['image_url'],
        prs: image_params['prs'],
        access_key: image_params['access_key'],
        secret_key: image_params['secret_key'],
        app_name: image_params['app_name'],
        app_version: image_params['app_version'],
        phone_type: image_params['phone_type'],
        phone_os: image_params['phone_os'],
        lat: image_params['lat'],
        long: image_params['long'],
        phone_uuid: image_params['phone_uuid'],
        user_id: image_params['user_id']
    }

    if image_params['image_parameters']
      @image_params.merge!(
          {
              image_parameters: {
                  x: image_params['image_parameters']['x'],
                  y: image_params['image_parameters']['y'],
                  width: image_params['image_parameters']['width'],
                  height: image_params['image_parameters']['height']
              }
          })
    end

    begin
      save(benchmark_id, new_benchmark_obj)
    rescue => e
      Sidekiq.logger.error e.message
      st = e.backtrace.join("\n")
      Sidekiq.logger.error st
    ensure
      TempFileHelper::delete_quite(@decoded_file)
    end
  end

  private

  def save(benchmark_id, new_benchmark_obj)
    benchmark = nil
    ActiveRecord::Base.transaction do
      if benchmark_id.nil?
        benchmark = ExecutionBenchmark.create(new_benchmark_obj)
      else
        benchmark = ExecutionBenchmark.find(benchmark_id)
        new_benchmark_obj['details'] = new_benchmark_obj['details'].merge(benchmark.details)
        benchmark.update_attributes(new_benchmark_obj)
        benchmark.save!
      end

      benchmark.update_attributes(action_date: benchmark.created_at)

      unless @image_params[:image].blank? && @image_params[:image_url].blank?
        unless benchmark.image.file.present?
          save_query_image(benchmark)
        end

        unless benchmark.benchmark_multi_object_crops.blank?
          benchmark.benchmark_multi_object_crops.each do |object|
            unless object.image.file.present?
              object.remote_image_url = benchmark.image.cropped_url
              object.save!
            end
          end
        end
      end
    end

    begin
      country_json = update_country_info(benchmark)
      if benchmark.main
        # Send info to analytic service
        send_analytics(country_json)
      end
    ensure
      if benchmark.main
        controller = Api::V1::SnappedProductsController.new
        controller.capture_from_benchmark(benchmark.id)
      end
    end
  end

  def send_analytics(country_json)
    crop_params = {
        app_name: @image_params[:app_name],
        app_version: @image_params[:app_version],
        phone_type: @image_params[:phone_type],
        phone_os: @image_params[:phone_os],
        lat: @image_params[:lat],
        long: @image_params[:long],
        phone_uuid: @image_params[:phone_uuid],
        user_id: @image_params[:user_id]
    }

    if crop_params[:lat].blank? or crop_params[:long].blank?
      unless country_json.blank? or country_json['latitude'].blank? or country_json['longitude'].blank?
        crop_params[:lat] = country_json['latitude']
        crop_params[:long] = country_json['longitude']
      end
    end

    begin
      Sidekiq.logger.info "Call ulab crop api with params: #{crop_params.as_json}"

      ulab_req = UlabRequests.new(crop_params)
      response = ulab_req.crop
      response_body = ActiveSupport::JSON.decode(response.body || '{}')

      if response_body['status_code'].to_i == 200
        Sidekiq.logger.info 'Call ulab crop api success'
      else
        Sidekiq.logger.info "Call ulab crop api failed with response: #{response_body.as_json}"
      end
    rescue StandardError => e
      Sidekiq.logger.error "Call ulab request failed: #{e.response}"
    end
  end

  def save_query_image(benchmark)
    unless @image_params[:image].blank?
      @decoded_file = TempFileHelper::create_from_base64(@image_params[:image].to_s)
      benchmark.image = @decoded_file
    end
    unless @image_params[:image_url].blank?
      benchmark.remote_image_url = @image_params[:image_url]
    end
    benchmark.save!
  end

  def update_country_info(benchmark)
    return if benchmark.details['remote_ip'].blank?

    ip = benchmark.details['remote_ip']

    response = nil
    begin
      response = RestClient.get("http://freegeoip.net/json/#{ip}")
      json = JSON.parse(response)
      benchmark.update_attributes({
                                      country_code: json['country_code'],
                                      country_name: json['country_name'],
                                  })

      json
    rescue => e
      puts "IP #{ip} .Error (#{e}) parsing json: #{response} #{result}"
    end
  end

  def is_being_call_ulab_prs?
    ImageRecognition::SendImageForAnalysisService::is_using_ulab_prs?(@image_params)
  end
end
