module Base64ImageHelper
  def self.decode_picture(base64)
    # Decode the base64
    encoded_data_begin_at = base64.index(';base64,') + ';base64,'.length - 1
    picture_data = StringIO.new(Base64.decode64(base64[encoded_data_begin_at .. -1]))

    # Assign some attributes for carrier wave processing
    picture_data.class.class_eval { attr_accessor :original_filename, :content_type }
    picture_data.content_type = content_type(base64)
    picture_data.original_filename = "#{DateTime.now.strftime('%s')}_avatar#{Rack::Mime::MIME_TYPES.invert[picture_data.content_type]}"

    picture_data
  end

  def self.content_type(base64)
    begin_at = base64.index('data:') + 'data:'.length
    end_at = base64.index(';base64,') - 1

    base64[begin_at .. end_at]
  end

  def self.read_from_url_as_base64(url)
    content = nil
    open(url) do |url_file|
      content = Base64.encode64(url_file.read)
    end
    content
  end
end