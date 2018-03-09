class Panel::UpdateManualTrainingService
  def initialize(manual_training, form)
    @manual_training = manual_training
    @form = form
  end

  def call
    ActiveRecord::Base.transaction do
      update_manual_training
      add_linked_products
    end
    @manual_training
  end

  private

  def update_manual_training
    @manual_training.update_attributes(
        {
            product: @form.manual_training_products[0].product,
            category: @form.manual_training_products[0].product&.product_categories&.first&.category&.imaging_category
        })
  end

  def add_linked_products
    Panel::UpdateManualTrainingProductsService.new(@manual_training, @form).call
  end

end