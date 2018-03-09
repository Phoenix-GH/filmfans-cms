class MediaContainer < ActiveRecord::Base
  has_many :tags, dependent: :destroy
  has_many :home_contents, as: :content, dependent: :destroy
  has_many :collection_contents, as: :content, dependent: :destroy
  has_one :media_content, as: :membership, dependent: :destroy

  belongs_to :owner, polymorphic: true

  scope :until, -> (timestamp) { where('created_at <= ?', Time.at(timestamp)) }

  def self.videos
    ids = joins(:media_content).where('media_contents.file_type LIKE ?', 'video/%').map(&:id)
    self.where(id: ids)
  end

  def cover_image
    #media_content&.file&.url&.to_s
    media_content&.file_thumb_url&.to_s
  end

  def cover_image_url
    cover_image
  end

  def media_type
    if media_content.video?
      'Video'
    elsif media_content.image?
      'Image'
    end
  end

  def owner_string
    "#{owner_type}:#{owner_id}"
  end
end
