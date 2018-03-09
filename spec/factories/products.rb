FactoryGirl.define do
  factory :product do
    name { Faker::StarWars.specie }
    brand { Faker::StarWars.planet }
    product_code { Faker::StarWars.droid }
    description { Faker::StarWars.quote }
    price_range nil

    after(:create) do
      Product.reindex
      Product.searchkick_index.refresh
    end
  end

  trait :with_product_file do
    after(:create) do |parent|
      pf = create(:product_file, :with_cover_image, :with_file_type_image, product: parent)
      pf.save
      parent.product_files = pf
      parent.save
    end
  end


  trait :with_product_files do
    after(:create) do |parent|
      pf1 = create(:product_file, :with_cover_image, :with_file_type_image, product: parent)
      pf2 = create(:product_file, :with_cover_image, :with_file_type_image, product: parent)
      pf3 = create(:product_file, :with_cover_image, :with_file_type_image, product: parent)
      pf1.save
      pf2.save
      pf3.save

      parent.product_files = [pf1, pf2, pf3]
      parent.save
    end
  end

  trait :with_product_file_urls do
    after(:create) do |parent|
      pf = create(:product_file, :with_urls) #, product: parent)
      pf.save
      parent.product_files = pf
      parent.save
    end
  end
end
