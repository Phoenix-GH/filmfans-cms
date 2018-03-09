class ProductsPresenter

  def category_main_options
    Category.list_display_categories
  end
end
