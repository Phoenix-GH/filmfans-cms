class Api::V1::TvShowsController < Api::V1::BaseController
  def index
    results = TvShowQuery.new(tv_show_params).results
    json = results.map { |tv_show| TvShowSerializer.new(tv_show).results }

    render json: json
  end

  def show
    tv_show = TvShow.find(params[:id])

    render json: TvShowSerializer.new(tv_show, with_episodes: true).results
  end

  private
  def tv_show_params
    params.permit(:channel_id, :page, :per, :current_country).merge(visibility: true)
  end
end
