class Episode < ActiveRecord::Base
  belongs_to :tv_show_season

  mount_uploader :cover_image, PictureUploader
  mount_uploader :file, VideoUploader

  serialize :specification, JSON
end
