class Channel < ActiveRecord::Base
  has_many :followings, as: :followed, dependent: :destroy
  has_many :channel_media_owners, dependent: :destroy
  has_many :media_owners, through: :channel_media_owners
  has_many :sources, dependent: :destroy, as: :source_owner
  has_many :posts, through: :sources
  has_many :media_containers, dependent: :nullify, as: :owner
  has_many :tv_shows, dependent: :destroy
  has_many :links, dependent: :destroy, as: :target
  has_one :trending, dependent: :destroy
  has_many :magazines, dependent: :destroy
  has_many :manual_posts, dependent: :destroy

  belongs_to :channel_country

  has_one :picture, class_name: 'ChannelPicture', dependent: :destroy

  accepts_nested_attributes_for :picture, :channel_country

  # THIS METHOD AND COLUMN NEEDS TO BE REMOVED AFTER CreateChannelPictures migration is run
  mount_uploader :image, PictureUploader

  after_save :update_dialogfeed, if: :dialogfeed_url_changed?

  def all_sources
    Source.where('(source_owner_id = ? AND source_owner_type = ?) OR (source_owner_id IN (?) AND source_owner_type = ?)', self.id, 'Channel', active_media_owner_ids, 'MediaOwner')
  end

  def all_posts
    Post.where('source_id IN (?)', all_sources.map(&:id))
  end

  def all_manual_posts
    ids = active_media_owner_ids
    if ids.blank?
      ManualPost.where('(channel_id = ?)', self.id)
    else
      ManualPost.where('(channel_id = ? OR media_owner_id in (?))', self.id, ids)
    end
  end


  def all_video_media_containers
    MediaContainer.videos.where('(owner_id = ? AND owner_type = ?) OR (owner_id IN (?) AND owner_type = ?)', self.id, 'Channel', active_media_owner_ids, 'MediaOwner')
  end

  def update_dialogfeed(remove_old = true)
    Panel::ManageDialogfeedService.perform_async(self.class.name, self.id, self.dialogfeed_url, remove_old)
  end

  def cover_image_url
    picture&.custom_url
  end

  def country
    channel_country
  end

  def active_media_owner_ids
    media_owners.where(feed_active: true).map(&:id)
  end
end
