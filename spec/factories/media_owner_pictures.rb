FactoryGirl.define do
  factory :media_owner_picture do
    file { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
  end
end