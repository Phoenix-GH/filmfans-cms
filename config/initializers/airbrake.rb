Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']

# Errbit:
#  config.host    = ENV['AIRBRAKE_HOST']
#  config.port    = ENV['AIRBRAKE_PORT'].to_i
#  config.environment_name = ENV['AIRBRAKE_ENV_NAME']
#  config.secure  = config.port == 443
end
