class Json::CollectionsController < ApplicationController
  def index
    @collections = CollectionQuery.new(search_params.merge({search: search_params[:term]})).results

    render json: @collections.map { |collection|
      {
        text: collection.name,
        id: collection.id,
        image: collection.cover_image&.custom_url
      }
    }
  end

  private

  def search_params
    params.permit(:term).merge(admin_id: current_admin.id)
  end
end
