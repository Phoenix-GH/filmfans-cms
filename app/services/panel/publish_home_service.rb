class Panel::PublishHomeService
  def initialize(home)
    @home = home
  end

  def call
    unpublish_homes
    @home.update_attribute(:published, true)
  end

  private

  def unpublish_homes
    Home.where(published: true, home_type: Home.home_types[@home.home_type]).update_all(published: false)
  end
end
