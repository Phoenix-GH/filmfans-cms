class TempImage < ActiveRecord::Base
  mount_uploader :image, PictureUploader

  serialize :specification, JSON
end
