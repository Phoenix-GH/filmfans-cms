module LogHelper
  def self.log_exception(e)
    Rails.logger.error e.message
    st = e.backtrace.join("\n")
    Rails.logger.error st
  end
end