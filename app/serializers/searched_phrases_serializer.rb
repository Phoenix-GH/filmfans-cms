class SearchedPhrasesSerializer
  def initialize(searched_phrase)
    @searched_phrase = searched_phrase
  end

  def results
    return {} unless @searched_phrase.phrase.present?
    generate_searched_phrase_json
  end

  private
  def generate_searched_phrase_json
    {
      phrase: @searched_phrase.phrase.to_s
    }
  end
end
