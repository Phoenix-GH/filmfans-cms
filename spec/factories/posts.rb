FactoryGirl.define do
  factory :post do
    published_at { Faker::Time.between(Time.now - 7.days, Time.now - 1.second) }
    content_title { Faker::Book.title }
    content_body { Faker::Lorem.sentence }
    content_video nil
    content_picture nil
    post_url { Faker::Internet.url }
    uid { Faker::Number.number(9) }

    factory :image_post do
      content_picture { File.open("#{Rails.root}/spec/fixtures/files/my_picture.png") }
      post_type 'image'
    end

    factory :video_post do
      content_video { File.open("#{Rails.root}/spec/fixtures/files/video.mp4") }
      post_type 'video'
    end
  end
end
