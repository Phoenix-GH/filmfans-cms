class Panel::UpdateThreedModelForm < Panel::BaseThreedModelForm

  def initialize(threed_model_attrs, form_attributes = {})
    super threed_model_attrs.merge(form_attributes)
  end

end