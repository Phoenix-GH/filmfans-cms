FactoryGirl.define do
  factory :events_container do
    channel nil
    name { Faker::StarWars.quote }
  end
end
