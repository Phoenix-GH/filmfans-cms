module TempFileHelper
  def self.create_from_base64(base64)
    create(Base64.decode64(base64))
  end

  def self.new_temp_file(file_name_prefix, file_name_ext)
    Tempfile.new([file_name_prefix, file_name_ext])
  end

  def self.create(string)
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(string)
    temp_file.rewind

    temp_file
  end

  def self.create_from_url(url)
    TempFileHelper::from_url(url)
  end

  def self.create_from_url_as_base64(url)
    TempFileHelper::from_url(url, true)
  end

  def self.delete_quite(temp_file)
    return if temp_file.blank?

    begin
      temp_file.close
      temp_file.unlink
    rescue => e
      LogHelper::log_exception(e)
    end
  end

  private
  def self.from_url(url, as_base64 = false)
    temp_file = Tempfile.new
    begin
      temp_file.binmode
      open(url) do |url_file|
        if as_base64
          temp_file.write(Base64.encode64(url_file.read))
        else
          temp_file.write(url_file.read)
        end
      end
      temp_file.rewind
    rescue => e
      TempFileHelper::delete_quite(temp_file)
      raise e
    end

    temp_file
  end
end