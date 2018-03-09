class Panel::UpdateMediaContainerForm
  include ActiveModel::Model

  attr_reader :media_content
  attr_accessor(
    :owner, :name, :description, :additional_description, :media_content_id
  )

  def initialize(media_container_attrs, form_attributes = {})
    super media_container_attrs.merge(form_attributes)
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

  validates :name, presence: true
  validate :validate_media_content
  validates :owner, presence: true

  def media_container_attributes
    {
      owner: @owner,
      name: name,
      description: description,
      additional_description: additional_description,
      media_content: @media_content
    }
  end

  private
  def validate_media_content
    if media_content_id.blank?
      errors[:base] << _('First upload file. Allowed formats: image or video')
    end
  end
end
