class Movie::UniversalSearchService
  TOPIC_SEARCH_PER = 5
  SEARCH_PER = 15

  def initialize(client_ip)
    @gracenote_service = Movie::GracenoteMovieService.new(client_ip)
  end

  def search(search:, page:)
    return [] if search.blank?
    movie_page = 0 # gracenote page start with 0
    post_page = 1
    merch_page = 1
    unless page.blank?
      tokens = page.split('|')
      if tokens.length >= 1
        movie_page = tokens[0].to_i
      end
      if tokens.length >= 2
        post_page = tokens[1].to_i
      end
      if tokens.length >= 3
        merch_page = tokens[2].to_i
      end
    end

    movies = @gracenote_service.search_movies(search, movie_page, TOPIC_SEARCH_PER)[:movies]
    posts = search_manual_posts(search, post_page, TOPIC_SEARCH_PER)
    merchs = search_merchandise(search, merch_page, TOPIC_SEARCH_PER)

    if movies.length + posts.length + merchs.length < SEARCH_PER
      if movies.length == TOPIC_SEARCH_PER
        movie_page += 1
        movies += @gracenote_service.search_movies(search, movie_page, TOPIC_SEARCH_PER)[:movies]
      end
    end
    if movies.length + posts.length + merchs.length < SEARCH_PER
      if posts.length == TOPIC_SEARCH_PER
        post_page += 1
        posts += search_manual_posts(search, post_page, TOPIC_SEARCH_PER)
      end
    end
    if movies.length + posts.length + merchs.length < SEARCH_PER
      if merchs.length == TOPIC_SEARCH_PER
        merch_page += 1
        merchs += search_merchandise(search, merch_page, TOPIC_SEARCH_PER)
      end
    end

    movie_page += 1 if movies.length > 0
    post_page += 1 if posts.length > 0
    merch_page += 1 if merchs.length > 0

    # don't sort by name, just priority movie first
    results = movies.map { |m| {movie: m, celeb: nil, merch: nil} } +
        posts.map { |p| {movie: nil, celeb: ManualPostSerializer.new(p, true).result_embed_one_product, merch: nil} } +
        merchs.map { |p| {movie: nil, celeb: nil, merch: ProductSerializer.new(p, with_similar_products: false).results} }
    {
        results: results,
        next_page: results.empty? ? nil : "#{movie_page}|#{post_page}|#{merch_page}"
    }
  end

  private

  def search_manual_posts(search, page, per)
    ManualPostQuery.new({visible: true,
                         trending: true,
                         per: per,
                         page: page,
                         search: search
                        }).results
  end

  def search_merchandise(search, page, per)
    MovieQuery.new({per: per,
                    page: page,
                    search: search
                   }).results
        .map { |m| m.products }
        .flatten
  end
end