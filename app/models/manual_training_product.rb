class ManualTrainingProduct < ActiveRecord::Base
  belongs_to :manual_training
  belongs_to :product
end