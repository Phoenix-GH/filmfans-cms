class Json::BenchmarksController < ApplicationController

  def keywords
    render json: get_keywords(image_url_params[:image_url])
  end

  def update_threshold
    RestClient.put("#{ENV['PRS_ULAB_PROXY_URL']}/ma/threshold",
                   threshold_params.to_json,
                   {content_type: 'application/json; charset=utf-8', accept: :json}) { |res|
      case res.code
        when 200
          render json: {
              name: threshold_params[:name],
              value: threshold_params[:value]
          }
        else
          render json: {
              error: 'Update threshold failed'
          }
      end
    }
  end

  private
  def threshold_params
    params.permit(:name, :value)
  end

  def image_url_params
    params.permit(:image_url)
  end

  def get_keywords(image_url)
    response = {}

    if image_url.blank?
      response['message'] = 'Image url is empty'
    else
      begin
        RestClient.get("#{ENV['EXT_PRODUCT_KEYWORDS_URL']}/keywords?image_url=#{image_url.to_param}") { |res|
          case res.code
            when 200
              response = JSON.parse(res.body)
              if response.blank?
                response['message'] = 'Request ok, but response is empty'
              end
            else
              response['message'] = "Request completed with code: #{res.code}"
          end
        }
      rescue Exception => e
        response['message'] = 'Request failed'
        Rails.logger.error "Fail to get keywords from api. Message: #{e.message}"
      end
    end

    response
  end
end
