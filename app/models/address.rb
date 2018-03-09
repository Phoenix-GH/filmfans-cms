class Address < ActiveRecord::Base
  belongs_to :user

  scope :primary, -> { where(primary: true) }
end
