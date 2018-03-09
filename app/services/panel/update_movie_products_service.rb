class Panel::UpdateMovieProductsService
  def initialize(movie, form)
    @movie = movie
    @form = form
  end

  def call
    return false unless @form.valid?

    ActiveRecord::Base.transaction do
      remove_old_products
      create_new_products
    end
  end

  private

  def remove_old_products
    @movie.movie_products.delete_all
  end

  def create_new_products
    @form.movie_products.each do |product|
      position = product[:position]
      product = Product.find_by(id: product[:product_id])
      if product
        @movie.movie_products.create(product: product, position: position)
      end
    end
  end
end