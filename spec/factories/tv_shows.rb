FactoryGirl.define do
  factory :tv_show do
    channel_id 1
    cover_image nil
    title { Faker::Book.title }
    description { Faker::Hipster.paragraph }
    background_image nil

    trait :with_cover_image do
      cover_image { FactoryGirl.create(:tv_show_cover_image) }
    end

    trait :with_background_image do
      background_image { FactoryGirl.create(:tv_show_background_image) }
    end
  end

  trait :with_2_seasons do
    after(:create) do |parent|
      create_list :tv_show_season, 2, tv_show: parent
    end
  end

  trait :with_1_season_2_episodes do
    after(:create) do |parent|
      create :tv_show_season, :with_2_episodes, tv_show: parent
    end
  end
end
