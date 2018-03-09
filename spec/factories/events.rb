FactoryGirl.define do
  factory :event do
    name { Faker::StarWars.quote }
    cover_image nil
    background_image nil

    trait :with_cover_image do
      cover_image { FactoryGirl.create(:event_cover_image) }
    end

    trait :with_background_image do
      background_image { FactoryGirl.create(:event_background_image) }
    end
  end
end
