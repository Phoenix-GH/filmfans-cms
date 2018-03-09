class Panel::BaseManualPostForm
  include ActiveModel::Model

  attr_accessor(:name, :owner_id, :channel_id, :media_owner_id, :image, :video, :visible, :display_option)

  validates :name, :visible, presence: true

  def attributes
    {
        name: name,
        channel_id: channel_id,
        media_owner_id: media_owner_id,
        image: image,
        video: video,
        visible: visible,
        display_option: display_option
    }
  end

end
