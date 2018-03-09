class Panel::UpdateThreedArForm < Panel::BaseThreedArForm

  def initialize(threed_ar_attrs, form_attributes = {})
    super threed_ar_attrs.merge(form_attributes)
  end

end