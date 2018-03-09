class ObscenityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || 'cannot be profane') if profane?(value, record.language)
  end

  def profane?(phrase, language)
    if language != 'en'
      Obscenity::Base.blacklist = load_language_yaml_file(language)
    end

    Obscenity.profane?(phrase)
  end

  private
  def load_language_yaml_file(language)
    file_path = File.join(Rails.root,"/config/obscenity/#{language}.yml")

    return unless File.exist?(file_path)
    YAML.load_file(file_path)
  end
end
