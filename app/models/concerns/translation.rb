module Translation
  extend ActiveSupport::Concern

  class Error < StandardError
  end

  module Errors
    class TranslationFieldMissing < Translation::Error
    end
    class FieldMissing < Translation::Error
    end
  end

  @@field = nil
  @@supportted_languages = []

  def self.field=(f)
    @@field = f
  end
  def self.field
    @@field
  end

  def self.supported_langs=(langs)
    @@supported_langs = langs
  end
  def self.supported_langs
    @@supported_langs
  end

  def self.default_lang=(lang)
    @@default_lang = lang
  end
  def self.default_lang
    @@default_lang
  end

  included do
    def validate_fields(*fields)
      fields.push(Translation.field)
      fields.each do |f|
        raise Errors::FieldMissing, "#{f} is not a valid attribute" unless respond_to?(f)
      end
    end
  end

  class_methods do
    def translate(*attrs, on_field: :translation)
      Translation.field = on_field
      Translation.supported_langs = ["en", "vi", "ko", "ms", "th", "zh"]
      Translation.default_lang = "en" # TODO: integrate with multi-tenant

      attrs.each do |attr|
        attr_s = attr.to_s

        define_method("#{attr}_all_langs") do
          validate_fields(attr)
          tr = translation || {}
          all_tr = Translation.supported_langs.map do |lang|
            if lang == Translation.default_lang
              [lang, self.send(attr)]
            else
              [lang, tr.dig(lang,attr_s)]
            end
          end.to_h
        end

        define_method("#{attr}[]") do |target_lang|
          validate_fields(attr)
          if target_lang == Translation.default_lang
            self.send(attr)
          else
            translation.dig(target_lang, attr_s) || ""
          end
        end

        # obj.name_all_langs = {"en" => "tienganh", "vi" => "tieng viet", etc}
        define_method("#{attr}_all_langs=") do |tr_all_langs|
          validate_fields(attr)
          supported_languages = Translation.supported_langs #SupportedLanguageQuery.instance.all_langs.map(&:code)

          params = ActionController::Parameters.new(tr_all_langs)
          permitted_tr = params.permit(supported_languages)

          attr_translation = supported_languages.map do |lcode|
            next if lcode == Translation.default_lang
            v = permitted_tr.dig(lcode) || ""
            [lcode, {attr_s => v}]
          end.reject(&:nil?).to_h

          self.translation = (self.translation || {}).deep_merge(attr_translation)

          self.send("#{attr_s}=", permitted_tr.dig(Translation.default_lang))
        end

        define_method("#{attr}_translation") do |country_code|
          validate_fields(attr)
          tr = translation.dig(country_code, "name")
          if tr.blank?
            name
          else
            tr
          end
        end

      end
    end
  end
end
