FactoryGirl.define do
  factory :product_file do
    product_id 1
    file_type ""
    file nil
    cover_image nil
    small_version_url nil
    normal_version_url nil
    large_version_url nil
  end

  trait :with_urls do
    large_version_url 'http://large_image.jpg'
    normal_version_url 'http://normal_image.jpg'
    small_version_url 'http://small_image.jpg'
  end
end
