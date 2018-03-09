class ImageFormatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.try(:tempfile).present?

    unless valid_extension?(value.original_filename)
      record.errors[attribute] << _('invalid format')
    end
  end

  private
  def valid_extension?(filename)
    ext = File.extname(filename)
    %w( .jpg .jpeg .png .gif ).include? ext.downcase
  end
end
