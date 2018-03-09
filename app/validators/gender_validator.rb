class GenderValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || _('Not a valid gender. Only allows male/female')) unless valid_gender?(value)
  end

  private
  def valid_gender?(gender)
    if gender.blank? || gender.downcase == 'male' || gender.downcase == 'female'
      return true
    end

    false
  end
end
