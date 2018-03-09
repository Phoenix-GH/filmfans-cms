class Api::V1::CollectionsController < Api::V1::BaseController
  def index
    collections = CollectionQuery.new(collections_params).results

    json = collections.map { |collection| CollectionSerializer.new(collection).results }

    render json: json
  end

  def show
    collection = Collection.find(params[:id])

    render json: CollectionSerializer.new(collection, true).results
  end

  private
  def collections_params
    params.permit(:page)
  end
end
