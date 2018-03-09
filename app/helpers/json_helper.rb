require 'json'

module JsonHelper
  def self.is_json?(json)
    begin
      !!JSON.parse(json)
    rescue
      false
    end
  end
end