class Api::V1::ProductImageIndexesController < Api::V1::BaseController
  def index
    results = ProductImageCsvExportQuery.new(search_params).results

    render json: results.map { |res| ProductImageIndexSerializer.new(res).results }
  end

  private

  def search_params
    params.permit(:system, :running, :used, :min_id, :page, :per)
  end
end
