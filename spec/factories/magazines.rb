FactoryGirl.define do
  factory :magazine do
    channel_id 1
    title { Faker::Book.title }
    description { Faker::Hipster.paragraph }
    cover_image nil

    trait :with_cover_image do
      cover_image { FactoryGirl.create(:magazine_cover_image) }
    end
  end

  trait :with_2_volumes do
    after(:create) do |parent|
      create_list :volume, 2, magazine: parent
    end
  end

  trait :with_1_volume_2_issues do
    after(:create) do |parent|
      create :volume, :with_2_issues, magazine: parent
    end
  end
end
