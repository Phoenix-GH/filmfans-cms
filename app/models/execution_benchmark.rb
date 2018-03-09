class ExecutionBenchmark < ActiveRecord::Base
  mount_uploader :image, SnappedProductPictureUploader
  has_many :benchmark_multi_object_crops, dependent: :destroy

  scope :likes, -> {where(like: true)}
  scope :dislikes, -> {where(like: false)}

  def image_file_size_pretty
    unless image.blank? || image.file.blank?
      begin
        Filesize.from("#{image&.file&.size} B").pretty
      rescue => e
        ''
      end
    end
  end

  def cropped_file_size_pretty
    unless image.blank? || image&.cropped.blank? || image&.cropped&.file.blank?
      begin
        Filesize.from("#{image&.cropped&.file&.size} B").pretty
      rescue => e
        ''
      end
    end
  end

  def crop_area
    return '' if details['image_parameters'].blank?
    crop = details['image_parameters']
    "[x: #{crop['x']}, y: #{crop['y']}, w: #{crop['width']}, h: #{crop['height']}]"
  end

  def origin_image_dimension
    return '' if image.blank?
    d = image.img_dimension
    "[w: #{d[0]}, h: #{d[1]}]"
  end

  def response_message
    message = details['result_message']
    unless message.blank? || message == 'Successfully' || message == 'OK'
      return message
    end
    nil
  end

  def response_keywords
    keywords = details['result_keywords']
    return nil if keywords.blank?
    keywords.join(', ')
  end

  def exec_app_netw
    return 0 if exec_crop_shop_total_app == 0
    exec_crop_shop_total_app - exec_crop_shop_total
  end

  def exec_crop_shop_total_app
    total_time_from_app&.to_i || 0
  end

  def exec_crop_shop_total
    execution_ms&.to_i || 0
  end

  def exec_prs_netw
    breakdown_2_ms&.to_i || 0
  end

  def exec_netw
    if exec_prs_netw && exec_prs_only
      return exec_prs_netw - exec_prs_only
    end
    nil
  end

  # within PRS
  def exec_prs_only
    breakdown_4_ms&.to_i || 0
  end

  def exec_prs_proxy_image_preprocessing
    details['prs_image_preprocessing_time_at_proxy'] || 0
  end

  def exec_prs_product_retrieval_time
    details['prs_product_retrieval_time'] || 0
  end

  def exec_prs_single_classification_time
    details['prs_single_classification_time'] || 0
  end

  def exec_prs_multi_classification_time
    details['prs_multi_classification_time'] || 0
  end

  def exec_prs_ma_time
    details['ma_time'] || 0
  end

  # ####
  def exec_hs_total
    breakdown_1_ms&.to_i || 0
  end

  def exec_hs_db
    breakdown_3_ms&.to_i || 0
  end

  def ordered_crops
    return [] if benchmark_multi_object_crops.blank?

    benchmark_multi_object_crops.sort_by do |object|
      object.id
    end
  end

  def using_ulab_prs?
    if details['prs_name'] == 'ULAB'
      return true;
    end

    cla = details['classifier']
    !cla.blank? && cla.match(/>/)
  end

  def app_name_version
    return nil if details['app_name'].blank?
    return details['app_name'] if details['app_version'].blank?
    "#{details['app_name']} #{details['app_version']}"
  end

  def is_multi_crops
    benchmark_multi_object_crops.count > 0
  end

  def predicted_categories
    return @predicted_categories unless @predicted_categories.blank?

    predicted_categories = []

    classifier = details['classifier']
    unless classifier.blank?
      predicted_categories = Category.where(imaging_category: classifier).map { |c| c.full_name }
    end

    @predicted_categories = predicted_categories
  end

  def search_categories
    details['search_categories']
  end

  def pids
    details['result_pids'] || []
  end

  def products
    @products ||= Product.where(id: pids.map { |id| id.to_i})
    @products = pids
                   .inject([]) { |result, pid| result << @products.detect { |p| p.id == pid } }
                   .compact # remove nil items
  end

  def top_products
    products[0..11]
  end

  def ordered_cropped_objects
    return @ordered_crops unless @ordered_crops.blank?
    @ordered_crops = []

    first_index = benchmark_multi_object_crops.index { |crop| !crop.pids.blank? }
    unless first_index.blank?
      @ordered_crops << benchmark_multi_object_crops[first_index]
    end
    benchmark_multi_object_crops.each_with_index do |crop, index|
      if index != first_index
        @ordered_crops << crop
      end
    end
    @ordered_crops
  end

  def sub_benchmark
    unless sub_benchmark_id.blank?
      ExecutionBenchmark.find(sub_benchmark_id)
    end
  end
end