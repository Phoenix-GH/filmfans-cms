FactoryGirl.define do
  factory :magazine_cover_image do
    file { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
  end
end