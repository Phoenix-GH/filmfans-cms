class AddHomesFromDropboxToDb
  def call
    ActiveRecord::Base.transaction do
      create_tv_show
      add_home
    end
  end

  private
  def create_tv_show
    puts 'Create tv show'
    channel = Channel.find_by(name: 'Shenzhen Media')
    tv_show = TvShow.new
    tv_show.title = 'Eat Drink Man & Woman'
    tv_show.remote_cover_image_url = 'http://image.ijq.tv/201510/21/14-33-40-71-12.jpg'
    tv_show.channel = channel
    tv_show.save

    season = tv_show.seasons.create(number: 1)
    season.episodes.create(
      remote_file_url: 'https://drive.google.com/file/d/0BycNr8-mbiYASnpaempYRkZTMXM/view',
      number: 1
      )
  end

  def add_home
    puts 'Create links'
    @home = Home.create(home_type: 2, published: true)
    add_magazine_link
    add_channel_link
    add_celebrity_link
    add_tv_show_link
    add_single_product_containers
  end

  def add_magazine_link
    magazine = Magazine.find_by(title: "Her World Thailand")
    link = Link.create(target: magazine)

    @home.home_contents.create(content: link, position: 1, width: 'full')
  end

  def add_channel_link
    channel = Channel.find_by(name: "Reve")
    link = Link.create(target: channel)

    @home.home_contents.create(content: link, position: 2, width: 'half')
  end

  def add_celebrity_link
    celebrity = MediaOwner.find_by(name: 'Stella Davis')
    link = Link.create(target: celebrity)

    @home.home_contents.create(content: link, position: 3, width: 'half')
  end

  def add_tv_show_link
    tv_show = TvShow.find_by(title: 'Eat Drink Man & Woman')
    link = Link.create(target: tv_show)

    @home.home_contents.create(content: link, position: 4, width: 'half')
  end

  def add_single_product_containers
    product = Product.find(4009842)

    @home.home_contents.create(content: product, position: 5, width: 'half')
  end
end


