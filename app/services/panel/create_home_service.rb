class Panel::CreateHomeService
  attr_reader :home

  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_home
  end

  private

  def create_home
    @home = Home.create(@form.home_attributes)
  end
end
