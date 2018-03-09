class MediaOwner < ActiveRecord::Base
  has_many :media_containers, dependent: :destroy
  has_many :products_containers, dependent: :destroy
  has_many :followings, as: :followed, dependent: :destroy
  has_many :channel_media_owners, dependent: :destroy
  has_many :channels, through: :channel_media_owners
  has_many :sources, dependent: :destroy, as: :source_owner
  has_many :posts, through: :sources
  has_many :media_containers, dependent: :nullify, as: :owner
  has_many :links, dependent: :destroy, as: :target
  has_many :manual_posts, dependent: :destroy

  has_one :picture, class_name: 'MediaOwnerPicture', dependent: :destroy
  has_one :background_image, class_name: 'MediaOwnerBackgroundImage', dependent: :destroy
  accepts_nested_attributes_for :picture
  accepts_nested_attributes_for :background_image

  after_save :update_dialogfeed, if: :dialogfeed_url_changed?

  alias_method :all_posts, :posts
  alias_method :all_manual_posts, :manual_posts

  def all_video_media_containers
    media_containers.videos
  end

  def cover_image
    picture&.custom_url
  end

  def cover_image_url
    cover_image
  end

  def update_dialogfeed(remove_old = true)
    Panel::ManageDialogfeedService.perform_async(self.class.name, self.id, self.dialogfeed_url, remove_old)
  end

  def as_json(options={})
    {:name => self.name, :id => self.id, :url => self.url}
  end
end
