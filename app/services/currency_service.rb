class CurrencyService
  APP_CURRENCY = 'USD'

  def self.convert_to_app_currency(price, currency)
    return nil if price.nil?

    if is_app_currency? currency
      return price
    else
      begin
        # exchange rate is configured in file money.rb
        money = Money.from_amount(price, currency).exchange_to(APP_CURRENCY)
        return money.amount
      rescue Exception => e
        Rails.logger.error e.message + " price #{price} from #{currency} to #{APP_CURRENCY}"
      end
    end

    nil
  end

  def self.get_first_price_in_app_currency(price_range_str)
    one_price_in_app_currency(price_range_str, true)
  end

  def self.get_last_price_in_app_currency(price_range_str)
    one_price_in_app_currency(price_range_str, false)
  end

  def self.is_app_currency?(currency)
    currency.nil? || currency.empty? || currency.casecmp(APP_CURRENCY) == 0 || currency == '$'
  end

  def self.get_exchange_rate(from_currency, to_currency)
    begin
      return Money.default_bank.get_rate(from_currency.upcase, to_currency.upcase)
    rescue Exception => e
      Rails.logger.error e.message + " from #{from_currency.upcase} to #{to_currency.upcase}"
    end
    0
  end

  private

  def self.one_price_in_app_currency(price_range_str, first)
    return nil if no_price_range?(price_range_str)

    begin
      coll = Monetize.parse_collection(price_range_str.to_s)
      price = first ? coll.first : coll.last
      if !price&.amount.present? || price.amount == 0
        price = first ? coll.last : coll.first
      end
      return CurrencyService::convert_to_app_currency(price.amount, price.currency.iso_code)
    rescue Exception => e
      Rails.logger.error e.message + ": price_range #{price_range_str}"
    end
    return nil
  end

  def self.no_price_range?(price_range)
    price_range.nil? || price_range.empty? || price_range == 'Currently unavailable.'
  end

end