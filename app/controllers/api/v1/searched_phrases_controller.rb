class Api::V1::SearchedPhrasesController < Api::V1::BaseController
  def index
    results = SearchedPhraseQuery.new(searched_phrases_params).results

    render json: results.map { |res| SearchedPhrasesSerializer.new(res).results }
  end

  private
  def searched_phrases_params
    params.permit(:search)
  end
end
