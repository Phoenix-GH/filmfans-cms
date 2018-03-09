class Panel::UpdateThreedModelService
  def initialize(threed_model, form)
    @threed_model = threed_model
    @form = form
  end

  def call
    return false unless @form.valid?

    update_threed_model
  end

  private

  def update_threed_model
    @threed_model.update_attributes(@form.attributes)
  end

end
