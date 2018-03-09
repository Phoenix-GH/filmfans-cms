class Json::CollectionContentsController < ApplicationController
  def index
    media_containers = MediaContainerQuery.new(search_params).results
    products_containers = ProductsContainerQuery.new(search_params).results
    combo_containers = ProductsContainerQuery.new(search_params.merge(with_media_owner: true)).results

    collection_contents = media_containers + products_containers + combo_containers
    render json: collection_contents.map { |object|
      {
        name: object.name,
        token: "#{object.class.to_s}_#{object.id}",
        image: object.cover_image&.thumb&.url,
        thumb: object.cover_image&.small_thumb&.url
      }
    }
  end

  private

  def search_params
    if current_admin.role == Role::Moderator
      params.permit(:search)
        .merge(channel_ids: current_admin.channel_ids)
        .merge(media_owner_ids: current_admin.media_owner_ids)
    else
      params.permit(:search)
    end
  end
end
