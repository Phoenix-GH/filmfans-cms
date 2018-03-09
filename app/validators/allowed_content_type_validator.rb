class AllowedContentTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.try(:tempfile).present?

    unless allowed_type?(value.content_type)
      record.errors[attribute] <<
        _('invalid format. Allowed formats: image or video')
    end
  end

  private
  def allowed_type?(content_type)
    content_type.match(/image\//).present? ||
      content_type.match(/video\//).present?
  end
end
