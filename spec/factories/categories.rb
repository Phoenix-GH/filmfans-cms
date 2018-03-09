FactoryGirl.define do
  factory :category do
    name "MyString"
    icon nil
    image nil
    parent_id nil
  end

  trait :with_image do
    image Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
  end

  trait :with_icon do
    icon Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
  end
end
