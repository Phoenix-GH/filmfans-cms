class Panel::CreateBenchmarkMultiObjectForm
  include ActiveModel::Model

  # IMPORTANT!!! this form shares with the API crop&shop

  attr_accessor(:image_url, :image_file)

  validate :image_url_xor_image_file

  def attributes
    {
        image_url: image_url,
        image_file: image_file
    }
  end

  private

  def image_url_xor_image_file
    unless image_url.blank? ^ image_file.blank?
      errors.add(:image_url, "Either image URL or image file must be provided")
    end
  end

end