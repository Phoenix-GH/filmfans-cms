FactoryGirl.define do
  factory :channel do
    name "MTV"
    picture { FactoryGirl.create(:channel_picture) }
  end

  trait :with_video_container do
    after(:create) do |parent|
      create(:media_container, :with_video, owner: parent)
    end
  end
end
