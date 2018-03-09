FactoryGirl.define do
  factory :media_owner do
    name { Faker::Name.name }
    picture { FactoryGirl.create(:media_owner_picture) }
    url { Faker::Internet.url }
    background_image { FactoryGirl.create(:media_owner_background_image) }
  end
end
