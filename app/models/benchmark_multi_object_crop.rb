class BenchmarkMultiObjectCrop < ActiveRecord::Base
  mount_uploader :image, BenchmarkMultiObjectCropUploader
  belongs_to :execution_benchmark

  # auto-crop category
  def box_category
    return '' if details.blank?
    details['category']
  end

  def area
    return '' if details.blank?
    # hash is used upon creation
    details['area'] || details[:area]
  end

  def area_as_xywh
    box = area
    return {} if box.blank?
    {
        x: box[0].to_i.abs,
        y: box[1].to_i.abs,
        width: box[2].to_i.abs - box[0].to_i.abs + 1,
        height: box[3].to_i.abs - box[1].to_i.abs + 1,
    }
  end

  def area_file_size
    unless image.blank? || image.file.blank?
      begin
        Filesize.from("#{image&.file&.size} B").pretty
      rescue => e
        ''
      end
    end
  end

  def box_probability
    return '' if details.blank?
    details['probability'].to_f.round(2)
  end

  def box_class
    return nil if details.blank?
    details['box_class']
  end

  def box_classification_info
    return nil if box_class.blank?
    "#{box_class} (#{box_probability})"
  end

  def image_url
    image.url
  end

  def response_message
    if tracking_detail.blank?
      message = nil
    else
      message = tracking_detail['result_message']
    end
    unless message.blank? || message == 'Successfully' || message == 'OK'
      return message
    end
    nil
  end

  def response_keywords
    if tracking_detail.blank?
      keywords = nil
    else
      keywords = tracking_detail['response_keywords']
    end
    unless keywords.blank?
      return keywords.join(', ')
    end
    nil
  end

  def classification_confidence
    if details.blank? || details['classification'].blank?
      return ''
    end
    details['classification']['confidence']&.to_f&.round(2)
  end

  def classification
    if details.blank? || details['classification'].blank?
      return nil
    end
    details['classification']['class_name']
  end

  def search_super_type
    return nil if details.blank?
    details['search_super_type']
  end

  def search_multi_categories
    return nil if details.blank?
    details['search_multi_categories']
  end

  def json_result
    return nil if details.blank?
    details['json_result']
  end

  def tracking_detail
    return {} if details.blank?
    details['image_tracking_detail'] || {}
  end

  def classification_time
    puts "details['classification_time'] #{details['classification_time']}"
    return nil if details.blank? || details['classification_time'].blank?
    (details['classification_time'].to_f * 1000).to_i
  end

  def using_ulab_prs?
    cla = tracking_detail['classifier']
    !cla.blank? && cla.match(/\s/)
  end

  def classifier_data
    unless classification_confidence.blank?
      if classification_confidence.blank?
        return "#{classification.upcase}"
      else
        if classification.blank? or classification_confidence.blank?
          return '-'
        else
          return "#{classification.upcase} (#{classification_confidence.to_f.round(2)})"
        end
      end
    end

    unless tracking_detail['classifier'].blank?
      if tracking_detail['classifier_probability'].blank?
        return "#{tracking_detail['classifier'].upcase}"
      else
        return "#{tracking_detail['classifier'].upcase} (#{tracking_detail['classifier_probability'].to_f.round(2)})"
      end
    end
    '-'
  end

  def predicted_categories
    return @predicted_categories unless @predicted_categories.blank?

    predicted_categories = []
    unless tracking_detail.blank?
      classifier = tracking_detail['classifier']

      unless classifier.blank?
        predicted_categories = Category.where(imaging_category: classifier).map { |c| c.full_name }
      end
    end
    @predicted_categories = predicted_categories
  end

  def search_categories
    unless tracking_detail.blank?
      tracking_detail['search_categories']
    end
  end

  def pids
    if tracking_detail.blank?
      []
    else
      tracking_detail['result_pids'] || []
    end
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
end