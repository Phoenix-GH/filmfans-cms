require 'money'
require 'money/bank/currencylayer_bank'


mclb = Money::Bank::CurrencylayerBank.new
mclb.access_key = "#{ENV['CURRENCY_LAYER_API_KEY']}"

# Update rates (get new rates from remote if expired or access rates from cache)
mclb.update_rates

# Force update rates from remote and store in cache
# mclb.update_rates(true)

# (optional)
# Set the seconds after than the current rates are automatically expired
# by default, they never expire
mclb.ttl_in_seconds = 28800

# (optional)
# Use https to fetch rates from CurrencylayerBank
# CurrencylayerBank only allows http as connection for the free plan users.
mclb.secure_connection = Rails.env.production?

# Define cache (string or pathname)
mclb.cache = Proc.new do |v|
  key = 'money:currencylayer_bank'
  if v
    Rails.cache.write(key, v)
    Rails.logger.info 'Refreshed exchange rates'
  else
    Rails.cache.read(key)
  end
end

# Set money default bank to currencylayer bank
Money.default_bank = mclb
