class EpisodeSerializer
  def initialize(episode)
    @episode = episode
  end

  def results
    return '' unless @episode
    generate_episode_json
  end

  private
  def generate_episode_json
    {
      episode_id: @episode.id.to_i,
      episode_number: @episode.number.to_i,
      episode_title: @episode.title.to_s,
      episode_cover_image: @episode.file.video_thumb.url.to_s,
      episode_file_url: @episode.file.url.to_s,
      episode_file_specification: @episode.specification.to_h
    }
  end
end
