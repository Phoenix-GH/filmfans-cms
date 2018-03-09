class Panel::CreateThreedModelService
  def initialize(form)
    @form = form
  end

  def call
    return false unless @form.valid?

    create_threed_model
  end

  private

  def create_threed_model
    @threed_model = ThreedModel.create(@form.attributes)
  end
end
