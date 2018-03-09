class Panel::CreateThreedArService

  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_threed_ar
  end

  private

  def create_threed_ar
    theed_ar = ThreedAr.create(@form.attributes)
    theed_ar.save
    theed_ar
  end
end