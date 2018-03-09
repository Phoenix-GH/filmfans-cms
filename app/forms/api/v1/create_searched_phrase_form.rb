class Api::V1::CreateSearchedPhraseForm
  include ActiveModel::Model

  attr_accessor :phrase, :language

  def initialize(phrase, language='en')
    @phrase = phrase
    @language = language
  end

  validates :phrase, obscenity: true
end
