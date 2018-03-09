FactoryGirl.define do
  factory :variant_file do
    variant_id 1
    file_type ""
    file nil
    cover_image nil
    small_version_url nil
    normal_version_url 'http://normal_image.jpg'
    large_version_url nil
  end
end
