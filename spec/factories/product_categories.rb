FactoryGirl.define do
  factory :product_category do
    product_id 1
    category_id 1

    after(:create) do
      Product.reindex
      Product.searchkick_index.refresh
    end

  end
end
