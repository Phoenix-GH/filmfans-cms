FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'password'
  end

  trait :with_token do
    tokens {{
      "ZabY2sushJ-lWCnmiE89uQ"=> {
        "token"=>"$2a$10$Am9v4s9qK87gULx4/2I5Je3Ae9SHQ0s.gbzw8K7MGlvRop96ksygK",
        "expiry"=>1458231832
      }
    }}
  end

  trait :with_profile do
    after(:create) do |parent|
      create(:profile, user: parent)
    end
  end

  trait :with_profile_with_picture do
    after(:create) do |parent|
      create(:profile, :with_profile_picture, user: parent)
    end
  end
end
