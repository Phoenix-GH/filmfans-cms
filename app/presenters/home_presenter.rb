class HomePresenter
  def initialize(home)
    @home = home
  end

  def content_options
    if ['trending', 'merchandise'].include?  @home.home_type
      [
          [_('Product'), 'Product'],
          [_('Collection Set'), 'CollectionsContainer'],
          [_('Product Set'), 'ProductsContainer'],
          [_('Media'), 'MediaContainer'],
          [_('Channel'), 'Channel'],
          [_('Celebrity'), 'MediaOwner'],
          [_('Magazine'), 'Magazine'],
          [_('TV Show'), 'TvShow'],
          [_("Event"), 'EventsContainer'],
          [_("Celebrity Trending"), 'ManualPostContainer'],
          [_("Movie"), 'Movie'],
          [_("Movie Set"), 'MoviesContainer']
      ]
    elsif ['up_coming', 'now_showing'].include? @home.home_type
      [
          [_("Movie Set"), 'MoviesContainer']
      ]
    else
      [
          [_('Product Set'), 'ProductsContainer'],
          [_('Collection Set'), 'CollectionsContainer']
      ]
    end
  end
end
