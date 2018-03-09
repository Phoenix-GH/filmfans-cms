class CreateMediaContentFromJson
  def initialize(record, object)
    @images = record
    @object = object
  end

  def call
    add_images(@images)
  end

  def add_images(images_data)

    object_files = get_object_files(images_data)

    if @object.class == Product
      unless @object.product_files.blank?
        object_files = [ object_files,
                        JSON.parse(@object.product_files.to_json)
                       ].flatten.reject(&:blank?).uniq
      end

      @object.product_files = object_files
    elsif @object.class == Variant
      unless @object.variant_files.blank?
        object_files = [ object_files,
                         JSON.parse(@object.variant_files.to_json)
                       ].flatten.reject(&:blank?).uniq
      end

      @object.variant_files = object_files
    end

    @object.save!
  end

  private

  def get_object_files(images_data)
    object_files = []

    if images_data.is_a? Array
      images_data.each { |image|
        object_files << {
          small_version_url: image['smallImage'] || '',
          normal_version_url: image['mediumImage'] || '',
          large_version_url: image['largeImage'] || '',
        }
      }
    elsif images_data.is_a? Hash
      object_files << {
        small_version_url: images_data['smallImage'] || '',
        normal_version_url: images_data['mediumImage'] || '',
        large_version_url: images_data['largeImage'] || '',
      }
    end

    object_files
  end
end
