class Panel::SearchedPhrasesController < Panel::BaseController
  before_action :set_searched_phrase, only: [:destroy]
  def index
    @searched_phrases = SearchedPhraseQuery.new(searched_phrases_search_params).results
  end

  def destroy
    @searched_phrase.destroy

    redirect_to panel_searched_phrases_path, notice: _('Phrase was successfully deleted.')
  end

  private
  def set_searched_phrase
    @searched_phrase = SearchedPhrase.find(params[:id])
  end

  def searched_phrases_search_params
    params.permit(:sort, :direction, :search, :page)
  end

  def sort_column
    ['phrase', 'counter'].include?(params[:sort]) ? params[:sort] : 'phrase'
  end
end
