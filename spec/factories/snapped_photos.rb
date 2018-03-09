FactoryGirl.define do
  factory :snapped_photo do
    user_id 1
    image Rack::Test::UploadedFile.new(
      File.open("#{Rails.root}/spec/fixtures/files/my_picture.png")
    )
  end
end
