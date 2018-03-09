class ManualTraining < ActiveRecord::Base
  belongs_to :product
  has_many :manual_training_products, dependent: :destroy
  has_many :products, through: :manual_training_products
  has_many :manual_training_user_images, dependent: :destroy

  def related_ids
    @related_ids ||= products.map { |p| p.id }.uniq.join(';')
  end
end