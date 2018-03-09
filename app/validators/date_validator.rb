require 'date'
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless value.present?
    record.errors[attribute] << (options[:message] || _('Not a valid date')) unless valid_date?(value)
  end

  private
  def valid_date?(date)
    is_valid_date = true
    begin
      Date.parse(date)
      is_valid_date = true
    rescue
      is_valid_date = false
    end
    is_valid_date
  end
end
