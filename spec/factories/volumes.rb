FactoryGirl.define do
  factory :volume do
    magazine_id 1
    year { rand(1960..2016) }
  end

  trait :with_2_issues do
    after(:create) do |parent|
      create_list :issue, 2, volume: parent
    end
  end
end
