class Panel::ManuallyTrainUserImageService

  def initialize(item, image_url)
    @item = item
    @image_url = image_url
  end

  def create
    @image_uuid = SecureRandom.uuid

    visenze = Panel::ManualTrainVisenzeService.new

    if visenze.add_user_image_to_index(@item, @image_uuid, @image_url)
      ManualTrainingUserImage.create(
          {
              manual_training: @item,
              image_url: @image_url,
              uuid: @image_uuid
          })
      return true
    end
    false
  end

  def delete(image_id)
    visenze = Panel::ManualTrainVisenzeService.new

    training_image = ManualTrainingUserImage.find(image_id)
    if visenze.remove_from_index([training_image.uuid])
      training_image.destroy
      return true
    end
    false
  end
end