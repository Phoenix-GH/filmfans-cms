class SnappedPhotoSerializer
  def initialize(snapped_photo)
    @snapped_photo = snapped_photo
  end

  def results
    return {} unless @snapped_photo

    generate_snapped_photo_json
  end

  private
  def generate_snapped_photo_json
    {
      id: @snapped_photo.id,
      image: @snapped_photo.image.url.to_s
    }
  end
end
