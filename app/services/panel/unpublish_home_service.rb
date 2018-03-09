class Panel::UnpublishHomeService
  def initialize(home)
    @home = home
  end

  def call
    @home.update_attribute(:published, false)
  end
end