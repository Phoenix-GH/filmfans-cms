FactoryGirl.define do
  factory :channel_picture do
    file { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
  end
end