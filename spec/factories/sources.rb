FactoryGirl.define do
  factory :source do
    dialogfeed_id { Faker::Number.between(30000, 40000) }
    name { Faker::StarWars.character }

    factory :facebook_source do
      website 'facebook'
    end

    factory :instagram_source do
      website 'instagram'
    end

    factory :twitter_source do
      website 'twitter'
    end
  end
end
