FactoryGirl.define do
  factory :variant_store do
    price { Faker::Commerce.price }
    currency ['PLN', 'EUR', 'USD'].sample
    url { Faker::Internet.url }
    variant_id 1
    sku 'B0012GLDCU'
    quantity 50
  end
end
