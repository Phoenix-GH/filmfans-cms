class Panel::UpdateVariantStoreService
  def initialize(variant_store, form)
    @variant_store = variant_store
    @form = form
  end

  def call
    return false unless @form.valid?

    update_variant_store
  end

  private

  def update_variant_store
    @variant_store.update_attributes(@form.attributes)
  end
end
