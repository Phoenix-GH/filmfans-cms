class GracenoteCelebrityDetailSerializer
  def initialize(celeb, client_ip)
    @celeb = celeb
    @service = Movie::GracenoteMovieService.new(client_ip)
  end

  def results
    {
        name: name,
        avatar_url: GracenoteMoveDetailSerializer::image_url(@celeb),
        credits: credits,
        bio: nil, # TODO no bio
        birth_date: birth_date,
        birth_place: @celeb['birthPlace'],
        social_accounts: social_accounts,
        movies: movies,
    }
  end

  private

  def name
    unless @celeb['name'].blank?
      return "#{@celeb['name']['first']} #{@celeb['name']['last']}"
    end
    return nil if @celeb['alternateNames'].blank?

    alt_name = @celeb['alternateNames'].first
    "#{alt_name['first']} #{alt_name['last']}"
  end

  def birth_date
    d = @celeb['birthDate']
    return nil if d.blank?
    year = d[0..3]
    month = d[5..6]
    day = d[8..9]
    return month if year.blank?
    return "#{Date::MONTHNAMES[month.to_i]}, #{year}" if day.blank?
    "#{Date::MONTHNAMES[month.to_i]} #{day}, #{year}"
  end

  def credits
    return [] if @celeb['credits'].blank?
    @celeb['credits'].map { |c| c['role'] }.uniq
  end

  def movies
    return [] if @celeb['credits'].blank?

    mvs = @celeb['credits'].select { |c| c['role'] == 'Actor' && c['type'].downcase == 'movie' }.map do |c|
      mv = @service.get_movie_detail(composite_id: "#{c['rootId']}@#{c['tmsId']}")
      {
          id: "#{c['rootId']}@#{c['tmsId']}",
          title: c['title'],
          character_name: c['characterName'],
          image_url: GracenoteMoveDetailSerializer::image_url(mv),
          year: c['year']
      }
    end

    # move no-image item to the end of the list, preserved the original order
    has_images = []
    no_images = []
    mvs.each { |p|
      if p[:image_url]&.include?('/generic/generic_')
        no_images << p
      else
        has_images << p
      end
    }
    has_images + no_images
  end

  def social_accounts
    m = MovieCelebrityMapping.find_by(person_id: @celeb['personId'], source: 'GRACENOTE')
    return nil if m.blank? || m.instagram_id.blank?

    if m.instagram_status == MovieCelebrityMapping::INSTAGRAM_STATUS_NOT_FOLLOWED
      # check again
      posts = Social::SocialService.new.get_feeds(following_ids: m.instagram_id, timestamp: nil, number_of_posts: 1)
      if posts.blank?
        return nil
      else
        m.update_attributes({instagram_status: nil})
      end
    end

    [
        {
            id: m.instagram_id,
            network: 'instagram'
        }
    ]
  end

end