FactoryGirl.define do
  factory :media_container do
    name { Faker::Name.name }
    description { Faker::Lorem.paragraph }
    additional_description { Faker::Hacker.say_something_smart }
    created_at { Faker::Time.between(Time.now - 7.days, Time.now - 1.second) }
  end

  trait :with_media_content do
    after(:create) do |parent|
      create(:media_content, :with_cover_image, :with_file_type_image, membership: parent)
    end
  end

  trait :with_video do
    after(:create) do |parent|
      create(:media_content, :with_file_type_video, membership: parent)
    end
  end
end
