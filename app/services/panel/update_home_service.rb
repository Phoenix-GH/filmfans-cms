class Panel::UpdateHomeService
  def initialize(home, form)
    @home = home
    @form = form
  end

  def call
    return false unless @form.valid?

    update_home
  end

  private

  def update_home
    @home.update_attributes(@form.home_attributes)
  end
end
