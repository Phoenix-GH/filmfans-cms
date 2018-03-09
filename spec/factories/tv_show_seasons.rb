FactoryGirl.define do
  factory :tv_show_season do
    tv_show_id 1
    sequence(:number) { |number| number }
  end

  trait :with_2_episodes do
    after(:create) do |parent|
      create_list :episode, 2, tv_show_season: parent
    end
  end
end
