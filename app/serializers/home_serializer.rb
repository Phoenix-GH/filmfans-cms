class HomeSerializer
  def initialize(home:, current_country:, language:)
    @home = home
    @current_country = current_country
    @language = language
  end

  def results
    return {} unless @home
    generate_home_json
    add_content_to_structure

    @home_json
  end

  private
  def generate_home_json
    @home_json = {
        home_type: @home.home_type.to_s,
        collections_containers: [],
        products_containers: [],
        media_containers: [],
        celebrity_trending_containers: [],
        combo_containers: [],
        single_product_containers: [],
        links_containers: [],
        events_containers: [],
        single_movie_containers: [],
        movies_containers: [],
        or_feature_count_threshold: Panel::SystemsController::or_feature_count_threshold
    }
  end

  def add_content_to_structure
    @home.home_contents.each do |home_content|
      add_content(home_content) if home_content.content.present?
    end
  end

  def add_content(home_content)
    if home_content.content_type == 'MediaContainer'
      generate_media_container_content(home_content)
    elsif home_content.content_type == 'CollectionsContainer'
      generate_collections_container_content(home_content)
    elsif home_content.content_type == 'ProductsContainer' && home_content.content.media_owner_id.present?
      generate_combo_container_content(home_content)
    elsif home_content.content_type == 'ProductsContainer'
      generate_products_container_content(home_content)
    elsif home_content.content_type == 'EventsContainer'
      generate_events_container_content(home_content)
    elsif home_content.content_type == 'MoviesContainer'
      generate_movies_container_content(home_content)
    elsif home_content.content_type == 'Movie'
      generate_single_movie_container_content(home_content)
    elsif home_content.content_type == 'Product'
      generate_single_product_container_content(home_content)
    elsif home_content.content_type == 'Link'
      generate_link_container_content(home_content)
    elsif home_content.content_type == 'ManualPostContainer'
      generate_celebrity_trending_content(home_content)
    end
  end

  def generate_media_container_content(home_content)
    media_container = MediaContainerSerializer.new(home_content.content).results
    @home_json[:media_containers] << media_container.merge(home_content_attributes(home_content))
  end

  def generate_collections_container_content(home_content)
    collections_container = CollectionsContainerSerializer.new(home_content.content).results
    @home_json[:collections_containers] << collections_container.merge(home_content_attributes(home_content))
  end

  def generate_combo_container_content(home_content)
    combo_container = ProductsContainerSerializer.new(home_content.content, @language).results
    @home_json[:combo_containers] << combo_container.merge(home_content_attributes(home_content))
  end

  def generate_products_container_content(home_content)
    product_container = ProductsContainerSerializer.new(home_content.content, @language).results
    @home_json[:products_containers] << product_container.merge(home_content_attributes(home_content))
  end

  def generate_events_container_content(home_content)
    event_container = EventsContainerSerializer.new(home_content.content).results
    @home_json[:events_containers] << event_container.merge(home_content_attributes(home_content))
  end

  def generate_movies_container_content(home_content)
    movie_container = MoviesContainerSerializer.new(home_content.content).results
    @home_json[:movies_containers] << movie_container.merge(home_content_attributes(home_content))
  end

  def generate_single_movie_container_content(home_content)
    single_movie_container = MovieSerializer.new(home_content.content).results
    @home_json[:single_movie_containers] << single_movie_container.merge(home_content_attributes(home_content))
  end

  def generate_single_product_container_content(home_content)
    single_product_container = ProductSerializer.new(home_content.content).results
    @home_json[:single_product_containers] << single_product_container.merge(home_content_attributes(home_content))
  end

  def generate_link_container_content(home_content)
    link = LinkSerializer.new(home_content.content, @current_country).results
    @home_json[:links_containers] << link.merge(home_content_attributes(home_content)) unless link.nil?
  end

  def generate_celebrity_trending_content(home_content)
    container = ManualPostContainerSerializer.new(home_content.content).results
    @home_json[:celebrity_trending_containers] << container.merge(home_content_attributes(home_content)) unless container.nil?
  end

  def home_content_attributes(home_content)
    {
        position: home_content.position,
        width: content_width(home_content)
    }
  end

  def content_width(home_content)
    home_content.width || 'full'
  end
end
