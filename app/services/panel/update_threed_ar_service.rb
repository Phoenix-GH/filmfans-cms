class Panel::UpdateThreedArService
  def initialize(threed_ar, form)
    @threed_ar = threed_ar
    @form = form
  end

  def call
    return false unless @form.valid?

    update_threed_ar
  end

  private

  def update_threed_ar
    @threed_ar.update_attributes(@form.attributes)
    @threed_ar
  end

end