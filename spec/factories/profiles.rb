FactoryGirl.define do
  factory :profile do
    user_id 1
    name { Faker::Name.name }
    surname { Faker::Name.name }
    picture nil
  end

  trait :with_profile_picture do
    remote_picture_url { Faker::Avatar.image }
  end
end
