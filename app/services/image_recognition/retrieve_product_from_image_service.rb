class ImageRecognition::RetrieveProductFromImageService
  def initialize(current_user, parameters)
    @current_user = current_user
    @parameters = parameters
  end

  def retrieve
    analysis_service = ImageRecognition::SendImageForAnalysisService.new(@parameters)
    image_metry_response = analysis_service.call
    @image_recognition_end2end_time = analysis_service.image_recognition_elapsed_time
    lookup_products(image_metry_response)
  end

  def lookup_products(image_metry_response)
    result = ImageRecognition::RetrieveProductFromImageService::empty_response

    Rails.logger.debug "PRS response: #{image_metry_response}"
    unless image_metry_response
      return {
          json_result: result,
          timing: {
              prs_total_time_with_network: @image_recognition_end2end_time,
              prs_total_execution_time: 0, # no network
              prs_single_classification_time: 0,
              prs_image_preprocessing_time_at_proxy: 0,
              prs_product_retrieval_time: 0,
              hs_product_lookup_time: 0,
              prs_multi_classification_time: 0
          },
          image_tracking_detail: {
              error_calling_image_recognition: true
          }
      }
    end

    prs_json = nil
    @hs_product_lookup_time = Benchmark.realtime {
      service = ImageRecognition::SnapProductsFromJsonService.new(
          image_metry_response,
          @current_user
      )
      if service.call
        @classifier = service.classifier
        @classifier_probability = service.classifier_probability
        @result_pids = service.result_pids
        @prs_result_pids = service.prs_result_pids
        @result_message = service.message.to_s
        @result_keywords = service.keywords
        prs_json = service.json

        result = result.merge(
            {
                message: service.message.to_s,
                man: service.man_products.map { |product|
                  ProductSerializer.new(product, with_similar_products: false).results
                },
                woman: service.woman_products.map { |product|
                  ProductSerializer.new(product, with_similar_products: false).results
                }
            })
      end
    }

    prs_json = {} if prs_json.nil?

    {
        json_result: result,
        timing: {
            prs_total_time_with_network: @image_recognition_end2end_time,
            prs_total_execution_time: get_timing(prs_json, 'execution_time'), # no network
            prs_single_classification_time: get_timing(prs_json, 'classification_time'),
            prs_image_preprocessing_time_at_proxy: get_timing(prs_json, 'image_preprocessing_time_at_proxy'),
            prs_product_retrieval_time: get_timing(prs_json, 'product_retrieval_time'),
            hs_product_lookup_time: @hs_product_lookup_time,
            prs_multi_classification_time: 0,
            ma_time: get_timing(prs_json, 'ma_time')
        },
        image_tracking_detail: {
            search_categories: prs_json['search_categories'],
            classifier: @classifier,
            classifier_probability: @classifier_probability,
            error_calling_image_recognition: false,
            result_pids: @result_pids,
            prs_result_pids: @prs_result_pids,
            result_message: @result_message,
            result_keywords: @result_keywords,
            sent_to_ma: prs_json['send_to_ma']
        }
    }
  end

  def self.empty_response
    {
        message: nil,
        man: [],
        woman: [],
        selected_sub_result_id: nil,
        sub_results: []
    }
  end

  private
  def get_timing(prs_json, key)
    return 0 if prs_json.blank?
    prs_json[key] || 0
  end

end