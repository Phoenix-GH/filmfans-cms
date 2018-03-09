class CarouselSerializer
  def initialize(client_ip:, zipcode:, latitude:, longitude:)
    @client_ip = client_ip
    @zipcode = zipcode
    @latitude = @latitude
    @longitude = @longitude
  end

  def results
    generate_carousel_json
  end

  private
  def generate_carousel_json
    #generate_categories_array
    #add_links_before_categories_array
    #add_links_after_categories_array


    # root_category = Category.where('lower(name) = ?', 'Disney store'.downcase).first
    # raise 'Not fond root Disney category' if root_category.nil?
    # disney_categories = CategorySerializer.new(root_category, true).results.merge(type: 'category')

    [
        {
            name: "Trending",
            type: "trending"
        },
        {
            name: "Now Showing",
            type: "now_showing",
            subcategories: Movie::GracenoteMovieService.new(@client_ip).list_genres(zipcode: @zipcode,
                                                                                    latitude: @latitude,
                                                                                    longitude: @longitude)
        },
        {
            name: "Up Coming",
            type: "up_coming"
        },
        {
            name: "Merchandise",
            type: "merchandise",
            subcategories: CategorySerializer::generate_categories_for_apps_merchandise
        },
        {
            name: "Celebrities",
            type: "media_owner_trendings",
            #subcategories: #Api::V1::ManualPostCarouselService.new.list_media_owner_having_manual_posts
        }
    ]
  end

  def generate_categories_array
    @array = Rails.cache.read('apps_display_categories')
    return @array unless @array.nil?

    parent_categories = CategoryQuery.new.results

    @array = parent_categories.map do |category|
      CategorySerializer.new(category, true)
          .results
          .merge(type: 'category')
    end

    roots = @array
    CarouselSerializer::cache_display_categories(roots)

    @array
  end

  def self.cache_display_categories(roots)
    Rails.cache.write('apps_display_categories', roots, time_to_idle: 1.hours, timeToLive: 3.hours)
  end

  def links_before_categories_array
    ['trending']
  end

  def add_links_before_categories_array
    links_before_categories_array.map do |link|
      @array.unshift(single_category_json(link))
    end
  end

  def links_after_categories_array
    ['tv', 'magazine']
  end

  def add_links_after_categories_array
    links_after_categories_array.map do |link|
      @array.push(single_category_json(link))
    end
  end

  def single_category_json(link)
    {
        name: link.camelize,
        icon_url: ENV["CAROUSEL_ICONS_#{link.upcase}"].to_s,
        type: link.downcase
    }
  end
end
