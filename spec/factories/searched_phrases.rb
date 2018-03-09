FactoryGirl.define do
  factory :searched_phrase do
    phrase { Faker::StarWars.quote }
    counter 1
  end
end
