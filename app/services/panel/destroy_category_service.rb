class Panel::DestroyCategoryService
  def initialize(category)
    @category = category
  end


  def call
    if @category.products.empty?
      destroy_category
    else
      false
    end
  end

  private

  def destroy_category
    @category.destroy
  end

end
