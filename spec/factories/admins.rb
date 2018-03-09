FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password 'password'
  end

  trait :superadmin do
    role 'super_admin'
  end
end
