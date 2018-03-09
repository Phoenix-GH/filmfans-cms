class GracenoteMoveDetailSerializer
  def initialize(movie, client_ip)
    @movie = movie
    @gracenoteService = Movie::GracenoteMovieService.new(client_ip)
  end

  def results
    return {} unless @movie
    generate_movie_json

    @movie_json
  end

  def self.image_url(json)
    return nil if json.blank? || json['preferredImage'].blank?

    uri = json['preferredImage']['uri']
    unless uri.start_with?('http://') || uri.start_with?('https://')
      # strip the buggy URI
      uri = uri.gsub(/^ulab\.tmsimg\.com/, '')
    end

    GracenoteMoveDetailSerializer::full_image_url(uri)
  end

  def self.full_image_url(suffix)
    return nil if suffix.blank?

    return suffix if suffix.start_with?('http://') || suffix.start_with?('https://')

    base_url = ENV['MOVIE_GRACENOTE_ASSET_BASE_URL']
    if base_url.end_with?('/')
      base_url = base_url[0..base_url.length - 2]
    end

    if suffix.start_with?('/')
      suffix = [0..suffix.length-1]
    end

    "#{base_url}/#{suffix}"
  end

  def self.extract_ratings_value(mv)
    return 0 if mv['qualityRating'].blank?
    mv['qualityRating']['value'].to_f
  end

  def self.is_invalid_image?(uri)
    uri.blank? || uri.include?('/generic/generic_')
  end

  private
  def generate_movie_json
    @movie_json = {
        id: movie_id,
        title: @movie['title'],
        image_url: GracenoteMoveDetailSerializer::image_url(@movie),
        genres: @movie['genres'],
        year: @movie['releaseYear'],
        run_time: run_time,

        ratings_value: GracenoteMoveDetailSerializer::extract_ratings_value(@movie),
        ratings_value_max: 4,
        ratings_vote_count: nil, # TODO ratings_vote_count
        synopsist: @movie['longDescription'],

        directors: @movie['directors'],
        writers: writers,
        casts: casts,

        has_trailer: has_trailer,
        has_ticket: true,

        outfits: outfits,
        merchandise: merchandise
    }
  end

  def movie_id
    "#{@movie['rootId']}@#{@movie['tmsId']}"
  end

  def writers
    return [] if @movie['crew'].blank?
    @movie['crew'].select { |c| c['role'].downcase.include?('writer') }.map { |c| c['name'] }
  end

  def casts
    return [] if @movie['cast'].blank?
    persons = @movie['cast'].select { |c| !c['characterName'].blank? }.map { |c|
      {
          personId: c['personId'],
          name: c['name'],
          characterName: c['characterName'],
          avatar_url: avatar_url(c['personId'])
      }
    }

    # move no-image item to the end of the list, preserved the original order
    has_images = []
    no_images = []
    persons.each { |p|
      if GracenoteMoveDetailSerializer::is_invalid_image?(p[:avatar_url])
        no_images << p
      else
        has_images << p
      end
    }
    has_images + no_images
  end

  def avatar_url(person_id)
    cele = @gracenoteService.celebrity_detail(person_id)
    GracenoteMoveDetailSerializer::image_url(cele)
  end

  def has_trailer
    trailer = @gracenoteService.get_trailer(movie_id)
    !trailer.blank? && trailer['url'].blank?
  end

  def run_time
    return nil if @movie['runTime'].blank? || @movie['runTime'].length < 8
    # Movie duration, specified in ISO-8601 format; PTxxHyyM = xx hours, yy minutes
    {
        hours: @movie['runTime'][2..3],
        minutes: @movie['runTime'][5..6]
    }
  end

  def outfits
    ManualPostQuery.new({visible: true,
                         trending: true,
                         per: 12,
                         page: 0,
                         search: @movie['title'],
                         search_exact: true
                        }).results.map { |p| ManualPostSerializer.new(p, true).result_embed_one_product }
  end

  def merchandise
    db_movie = Movie.find_by(gracenote_id: movie_id)
    return [] if db_movie.blank?
    db_movie.products.map { |product|
      ProductSerializer.new(product, with_similar_products: false).results
    }
  end
end