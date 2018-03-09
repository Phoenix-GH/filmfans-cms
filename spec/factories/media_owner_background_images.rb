FactoryGirl.define do
  factory :media_owner_background_image do
    file { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
  end
end