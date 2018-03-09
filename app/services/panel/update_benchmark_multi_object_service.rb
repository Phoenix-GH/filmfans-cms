class Panel::UpdateBenchmarkMultiObjectService
  def initialize(crop, form)
    @crop = crop
    @form = form
  end

  def call
    return false unless @form.valid?

    update
  end

  private

  def update
    @crop.update_attributes(@form.attributes.merge(
        {predicted_category: @crop.tracking_detail['classifier']}))
  end

end