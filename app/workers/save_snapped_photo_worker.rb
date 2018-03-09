class SaveSnappedPhotoWorker
  include Sidekiq::Worker

  def perform(user_id, encoded_image)
    ImageRecognition::SaveSnappedPhotoService.new(user_id, encoded_image).call
  end
end
