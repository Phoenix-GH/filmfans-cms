class Panel::BaseChannelForm
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor(
      :name, :picture, :media_owner_ids, :dialogfeed_url, :countries, :visibility
  )

  validates :name, presence: true
  validate :validate_countries

  def attributes
    country_codes = countries

    if global_country_code_exist?
      country_codes = []
    end

    # the multiselect component always return an empty element
    country_codes = country_codes.reject { |code| code == '' }

    {
        name: name,
        media_owner_ids: media_owner_ids,
        dialogfeed_url: dialogfeed_url,
        countries: country_codes,
        visibility: visibility
    }
  end

  def picture_attributes
    picture || {}
  end

  private

  def validate_countries
    return true if countries.blank?

    if global_country_code_exist?
      unless countries.index { |c| c != Country::CODE_GLOBAL and not c.blank? }.nil?
        errors.add :countries, 'Cannot mix Global with individual countries'
        return false
      end
    end
    true
  end

  def global_country_code_exist?
    countries&.include?(Country::CODE_GLOBAL)
  end
end