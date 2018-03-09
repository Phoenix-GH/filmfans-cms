class Panel::CreateMediaContainerForm
  include ActiveModel::Model

  attr_reader :media_content
  attr_accessor(
    :owner, :name, :description, :additional_description, :media_content_id
  )

  validates :name, presence: true
  validates :media_content_id, media_content_presence: true
  validates :owner, presence: true

  def initialize(attributes = {})
    super(attributes)
    @media_content = MediaContent.find(media_content_id) if media_content_id.present?
    if owner.present?
      if owner.class.in? [MediaOwner, Channel]
        @owner = owner
      elsif owner.is_a? String
        type = owner.split(':').first
        id = owner.split(':').last
        @owner = type.constantize.find(id)
      end
    end
  end

  def media_container_attributes
    {
      owner: @owner,
      name: name,
      description: description,
      additional_description: additional_description,
      media_content: @media_content
    }
  end
end
