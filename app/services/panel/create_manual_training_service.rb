class Panel::CreateManualTrainingService
  def initialize(form)
    @form = form
  end

  def call
    ActiveRecord::Base.transaction do
      create_manual_training
      add_linked_products
    end
    @manual_training
  end

  private

  def create_manual_training
    @manual_training = ManualTraining.create(
        {
            product: @form.manual_training_products[0].product,
            category: @form.manual_training_products[0].product&.product_categories&.first&.category&.imaging_category
        })
  end

  def add_linked_products
    Panel::CreateManualTrainingProductService.new(@manual_training, @form.manual_training_products).call
  end

end