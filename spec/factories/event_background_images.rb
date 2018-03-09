FactoryGirl.define do
  factory :event_background_image do
    file { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
  end
end