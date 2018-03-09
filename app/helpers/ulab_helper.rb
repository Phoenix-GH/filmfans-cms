module UlabHelper
  def self.parse_errors(messages)
    errors = nil

    unless messages.blank?
      if JsonHelper.is_json?(messages)
        errors = JSON.parse(messages)
      else
        errors = { full_messages: [messages] }
      end
    end

    errors
  end
end