class TvShowSeasonSerializer
  def initialize(season)
    @season = season
  end

  def results
    return '' unless @season
    generate_tv_show_season_json
    add_episodes

    @tv_show_season_json
  end

  private
  def generate_tv_show_season_json
    @tv_show_season_json = {
      season_id: @season.id.to_i,
      season_number: @season.number.to_i,
      season_episodes_count: @season.episodes.count.to_i
    }
  end

  def add_episodes
    episodes = @season.episodes.map do |episode|
      EpisodeSerializer.new(episode).results
    end

    @tv_show_season_json.merge!(episodes: episodes)
  end
end
