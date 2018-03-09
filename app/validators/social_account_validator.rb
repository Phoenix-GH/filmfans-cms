class SocialAccountValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || _("must be one of the followings: #{Provider.map { |p| p.to_s.titleize }}")) unless valid_social_account?(value)
  end

  private
  def valid_social_account?(provider)
    providers = Provider.map { |p| p.to_s}
    if providers.include? provider
      true
    else
      false
    end
  end
end
