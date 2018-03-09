FactoryGirl.define do
  factory :collection do
    trait :with_cover_image do
      cover_image { FactoryGirl.create(:collection_cover_image) }
    end

    trait :with_background_image do
      background_image { FactoryGirl.create(:collection_background_image) }
    end
  end

  trait :with_media_container do
    after(:create) do |parent|
      content = create(:media_container)
      create(:collection_content, collection_id: parent.id, content_type: 'MediaContainer', content_id: content.id)
    end
  end
end
