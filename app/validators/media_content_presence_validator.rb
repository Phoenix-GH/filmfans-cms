class MediaContentPresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless record.media_content_id.present?
      record.errors[:base] <<
        _('First upload file. Allowed formats: image or video')
    end
  end
end
