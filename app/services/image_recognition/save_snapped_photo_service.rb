class ImageRecognition::SaveSnappedPhotoService
  def initialize(user_id, image)
    @user_id = user_id
    @image = image
  end

  def call
    return false unless @user_id && @image.present? && @user = User.find(@user_id)

    decode_and_save
  end

  private
  def decode_and_save
    @decoded_file = TempFileHelper::create_from_base64(@image)

    begin
      save_decoded_photo
    ensure
      TempFileHelper::delete_quite(@decoded_file)
    end
  end

  def save_decoded_photo
    @user.snapped_photos.create(
      image: @decoded_file
    )
  end
end
