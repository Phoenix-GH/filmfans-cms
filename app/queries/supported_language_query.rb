require 'singleton'

class SupportedLanguageQuery < BaseQuery
  include Singleton

  def all_langs
    langs = Rails.cache.read('cms_supported_languages_all')
    return langs unless langs.nil?
    langs = SupportedLanguage.all.load
    Rails.cache.write('cms_supported_languages_all', langs)
    langs
  end

  def results
    prepare_query
    @results
  end

  private

  def prepare_query
    @results = SupportedLanguage.all
  end

end
