FactoryGirl.define do
  factory :issue do
    volume_id 1
    publication_date { Faker::Date.between(2.years.ago, Date.today) }
    pages { rand(30..200) }
    url { Faker::Internet.url }
    description { Faker::Hipster.paragraph }
    cover_image nil

    trait :with_cover_image do
      cover_image { FactoryGirl.create(:issue_cover_image) }
    end
  end
end
