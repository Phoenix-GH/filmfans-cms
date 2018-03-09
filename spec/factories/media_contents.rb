FactoryGirl.define do
  factory :media_content do
    file_type ""
    file nil
    cover_image nil
    membership_id 1
    membership_type 'Product'
  end

  trait :with_file_type_image do
    file Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
    file_type 'image/png'
    specification { { "height"=>40, "width"=>40 } }
  end

  trait :with_file_type_video do
    file Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/video.mp4"))
    file_type 'video/mp4'
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

  trait :with_cover_image do
    cover_image Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/files/my_picture.png"))
  end

  trait :invalid_image do
    cover_image { File.open("#{Rails.root}/spec/fixtures/files/empty.txt") }
  end
end
