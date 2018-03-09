FactoryGirl.define do
  factory :episode do
    tv_show_season_id 1
    cover_image nil
    file nil
    title { Faker::Book.title }
    sequence(:number) { |number| number }
  end

  trait :with_video_file do
    file Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
    specification {
      {
        'height'=>180,
        'width'=>320,
        'duration'=>0.976,
        'video_codec'=> 'mpeg4',
        'audio_codec'=> 'aac',
        'valid'=> true
      }
    }
  end
end
