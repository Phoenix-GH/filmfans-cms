class Api::V1::CreateSearchedPhraseService
  def initialize(form)
    @form = form
  end

  def call
    return unless @form.valid?

    find_or_create_phrase
    update_counter
  end

  private
  def find_or_create_phrase
    return if @form.phrase.size <= 3
    @searched_phrase = SearchedPhrase.find_or_create_by(phrase: @form.phrase)
  end

  def update_counter
    return unless @searched_phrase
    @searched_phrase.counter += 1
    @searched_phrase.save
  end
end
