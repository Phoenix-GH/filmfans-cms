# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
# avoid logging image binary
Rails.application.config.filter_parameters += [:password, :image, :picture]
