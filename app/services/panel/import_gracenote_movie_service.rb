class Panel::ImportGracenoteMovieService
  def initialize(gracenote_id, remote_ip)
    @gracenote_id = gracenote_id
    @gracenote_service = Movie::GracenoteMovieService.new(remote_ip)
  end

  def call
    do_import
  end

  private

  def do_import
    return if @gracenote_id.blank?

    g_movie = @gracenote_service.get_movie_detail(composite_id: @gracenote_id)
    return if g_movie.blank?
    img_uri = g_movie['preferredImage'].blank? ? nil : g_movie['preferredImage']['uri']

    attr = {
        gracenote_id: @gracenote_id,
        title: g_movie['title'],
        poster_image_thumbnail: img_uri,
        poster_images: img_uri,
        synopsist: g_movie['longDescription'],
        release_dates: g_movie['releaseDate'],
        website: g_movie['officialUrl']
    }

    m = Movie.find_by(gracenote_id: @gracenote_id)
    if m.blank?
      Movie.create(attr)
    else
      m.update_attributes(attr)
    end
  end

end