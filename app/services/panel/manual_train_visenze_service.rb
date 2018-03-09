class Panel::ManualTrainVisenzeService

  def add_all_to_index(manual_training)
    related_ids = manual_training.related_ids

    products = manual_training.products.map { |p|
      {
          im_name: p.id,
          image_url: product_image(p),
          category: manual_training.category,
          related_ids: related_ids,
      }
    }

    add_to_index(products)

    images = manual_training.manual_training_user_images.map { |img|
      {
          im_name: img.uuid,
          image_url: img.trained_image_url,
          category: manual_training.category,
          related_ids: related_ids,
      }
    }

    add_to_index(images)
  end

  def product_image(product)
    Product::fix_buggy_image_url(product.primary_image_object&.large_cover_image_url.to_s) ||
        Product::fix_buggy_image_url(product.primary_image_object&.thumb_cover_image_url.to_s) ||
        Product::fix_buggy_image_url(product.primary_image_object&.small_cover_image_url.to_s)
  end

  def add_user_image_to_index(manual_training, user_image_uuid, user_image_url)
    add_to_index(
        [{
             im_name: user_image_uuid,
             image_url: user_image_url,
             category: manual_training.category,
             related_ids: manual_training.related_ids,
         }])
  end

  def remove_from_index(im_name_arr)
    return if im_name_arr.blank?

    request_params = {}
    im_name_arr.each_with_index do |im_name, index|
      request_params.merge!(
          {
              "im_name[#{index}]" => im_name
          })
    end

    if Rails.env.development?
      puts "VISENZE remove params: #{request_params}"
      return
    end

    index_url = "#{ENV['VISENZE_URL']}/remove"
    ok = false
    resource = RestClient::Resource.new(index_url, ENV['VISENZE_MANUAL_APP_ACCESS_KEY'], ENV['VISENZE_MANUAL_APP_SECRETE_KEY'])
    resource.post(request_params,
                  {
                      accept: :json
                  }) { |response, request, result, &block|
      case response.code
        when 200
          # {
          #     "status": "OK",
          #     "method": "remove",
          #     "total": 2,
          #     "result": [
          # ],
          #     "error": []
          # }
          response = ActiveSupport::JSON.decode(response.body)
          if response['status'] == 'OK'
            ok = true
            Rails.logger.debug response
          else
            ok = false
            Rails.logger.error response
          end
        else
          Rails.logger.error response
      end
    }
    ok
  end

  private

  def add_to_index(attributes_arr)
    return if attributes_arr.blank?

    request_params = {}
    attributes_arr.each_with_index do |attributes, index|
      request_params.merge!(
          {
              "im_name[#{index}]" => attributes[:im_name],
              "im_url[#{index}]" => attributes[:image_url],
              "category[#{index}]" => attributes[:category],
              "related_ids[#{index}]" => attributes[:related_ids]
          })
    end

    if Rails.env.development?
      puts "VISENZE insert params: #{request_params}"
      return
    end

    index_url = "#{ENV['VISENZE_URL']}/insert"
    ok = false
    resource = RestClient::Resource.new(index_url, ENV['VISENZE_MANUAL_APP_ACCESS_KEY'], ENV['VISENZE_MANUAL_APP_SECRETE_KEY'])
    resource.post(request_params,
                  {
                      accept: :json
                  }) { |response, request, result, &block|
      case response.code
        when 200
          # {
          #     "status": "OK",
          #     "method": "insert",
          #     "trans_id": 246806789063168000,
          #     "total": 2,
          #     "result": [],
          #     "error": []
          # }
          response = ActiveSupport::JSON.decode(response.body)
          if response['status'] == 'OK'
            ok = true
            Rails.logger.debug response
          else
            ok = false
            Rails.logger.error response
          end
        else
          Rails.logger.error response
      end
    }
    ok
  end

end