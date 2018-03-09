FactoryGirl.define do
  factory :variant do
    product_id 1
    description { Faker::StarWars.quote }
  end

  trait :with_variant_file do
    after(:create) do |parent|
      # create(:variant_file, variant: parent)
      vf = create(:variant_file, variant: parent)
      vf.save
      parent.variant_files = vf
      parent.save

    end
  end

  trait :with_variant_file_urls do
    after(:create) do |parent|
      vf = create(:variant_file, :with_urls, variant: parent)
      vf.save
      parent.variant_files = vf
      parent.save
    end
  end

  trait :with_variant_store do
    after(:create) do |parent|
      store = Store.find_by(name: 'Amazon')
      store ||= create(:store, name: 'Amazon')
      create(:variant_store, variant: parent, store: store)
    end
  end
end
