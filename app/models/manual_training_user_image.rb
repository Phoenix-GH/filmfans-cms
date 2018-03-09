class ManualTrainingUserImage < ActiveRecord::Base
  belongs_to :manual_training

  def trained_image_url
    image_url
  end
end