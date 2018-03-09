class Link < ActiveRecord::Base
  belongs_to :target, polymorphic: true

  def name
    target.respond_to?(:name) ? target&.name : target&.title
  end

  def cover_image_url
    target.cover_image_url
  end

  def videos
    if  target_type == 'Channel'
      target.all_video_media_containers
    elsif target_type == 'TvShow'
      target.episodes
    else
      []
    end
  end
end
