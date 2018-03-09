class Variant < ActiveRecord::Base
  belongs_to :product
  has_many :option_value_variants, dependent: :destroy
  has_many :option_values, through: :option_value_variants
  has_many :variant_stores, dependent: :destroy
  # has_many :variant_files, dependent: :destroy
  has_many :variant_files_list, foreign_key: 'variant_id', class_name: 'VariantFileList'

  serialize :variant_files, VariantFilesJsonSerializer

  # validates :position, uniqueness: {scope: :product_id}, allow_blank: true

  def get_normalized_description
    description
        &.gsub("\\\"", "\"")
        &.gsub(/(<b>|<\/b>)/, '')
        &.gsub(/(<br>)/, " \n")
  end

  def sku
    variant_stores.first&.sku
  end

  def color
    get_option 'color'
  end

  def size
    get_option 'size'
  end

  def price
    variant_stores.first&.price
  end

  def currency
    variant_stores.first&.currency
  end

  def get_variant_image_url
    variant_image_url = []
    self.variant_files&.each do |file|
      variant_image_url.push(file) unless all_url_blank? file
    end

    # unneeded after removing old data
    #self.variant_files_list&.each do |file|
    #  variantImageUrl.push(file)  unless all_url_blank? file
    #end

    variant_image_url
  end

  def all_url_blank? file
    Variant::url_blank?(file&.large_cover_image_url) &&
        Variant::url_blank?(file&.small_cover_image_url) &&
        Variant::url_blank?(file&.thumb_cover_image_url)
  end

  def self.url_blank?(url)
    url.nil? || url.empty? || url.casecmp('None') == 0
  end

  private
  def get_option(name)
    option_type = OptionType.find_by name: name
    value = option_values.find_by option_type: option_type
    value&.name
  end
end
