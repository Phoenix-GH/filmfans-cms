class Api::V1::MagazinesController < Api::V1::BaseController
  def index
    results = MagazineQuery.new(magazine_params).results
    json = results.map { |magazine| MagazineSerializer.new(magazine).results }

    render json: json
  end

  def show
    magazine = Magazine.find(params[:id])

    render json: MagazineSerializer.new(magazine, with_issues: true).results
  end

  private
  def magazine_params
    params.permit(:channel_id, :page, :per, :current_country).merge(visibility: true)
  end
end
