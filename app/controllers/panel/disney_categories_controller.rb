class Panel::DisneyCategoriesController < Panel::BaseController
  skip_before_action :authenticate_admin!, :only => :index

  def index
    render_index params[:disney_cat], params[:ff_cat]
  end

  def update
    @form = Panel::DisneyCategoryMappingForm.new(update_form)

    if @form.valid?
      DisneyCategory.where(hierarchy: @form.disney_cat).update_all(new_name: @form.new_name)

      redirect_to panel_disney_categories_path(disney_cat: @form.disney_cat),
                  notice: _('The mapping has been saved successfully')

    else
      render_index @form.disney_cat, nil
    end
  end

  private

  def render_index disney_cat, ff_cat
    @total_product = query_disney_cate.count
    @hierarchies = query_disney_cate.where(new_name: nil).group(:hierarchy).order(:hierarchy).count
    @mapped_hierarchies = query_disney_cate.where.not(new_name: nil).group(:hierarchy).order(:hierarchy).count
    @ff_names = query_disney_cate.where.not(new_name: nil).group(:new_name).order(:new_name).count

    @ff_cat = ff_cat
    @disney_cat = disney_cat
    @current_cat = disney_cat || ff_cat

    if disney_cat.blank?
      @form = Panel::DisneyCategoryMappingForm.new
      unless ff_cat.blank?
        @image_urls = query_disney_cate.where(new_name: ff_cat).pluck(:image_url, :product_name)
        @mapped_hierarchies_for_ff_name = query_disney_cate.where(new_name: ff_cat).group(:hierarchy).order(:hierarchy).count
      end
    else
      # mapping form
      where = query_disney_cate.where(hierarchy: disney_cat)
      @image_urls = where.pluck(:image_url, :product_name)

      one_row = where.first
      @form = Panel::DisneyCategoryMappingForm.new(
          {disney_cat: disney_cat,
           new_name: one_row.nil? ? '' : one_row.new_name})
    end

    render :index, layout: 'no_nav_bar'
  end

  def query_disney_cate
    DisneyCategory.where(availability: 'in stock')
  end

  def update_form
    params.require(:remap_category_form).permit(:disney_cat, :new_name)
  end

end