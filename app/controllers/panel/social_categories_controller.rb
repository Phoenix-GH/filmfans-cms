class Panel::SocialCategoriesController < Panel::BaseController
  before_action :set_social_category, only: [:edit, :update, :destroy]

  def index
    @social_categories = SocialCategoryQuery.new(search_params).results
  end

  def order
    authorize! :update, SocialCategory
    @social_categories = SocialCategoryQuery.new(search_params.merge({no_paging: true, is_top: false})).results
  end

  def save_order
    authorize! :update, SocialCategory
    service = Panel::UpdatePositionService.new(SocialCategory, save_order_params[:ordered_ids])

    if service.call
      redirect_to panel_social_categories_path,
                  notice: _('Social category was successfully ordered.')
    else
      redirect_to order_panel_social_categories_path,
                  alert: _('Failed to order social categories!')
    end
  end

  def new
    @form = Panel::CreateSocialCategoryForm.new
  end

  def create
    @form = Panel::CreateSocialCategoryForm.new(social_category_params)
    service = Panel::CreateSocialCategoryService.new(@form)

    if service.call
      redirect_to panel_social_categories_path, notice: _('Category was successfully created.')
    else
      render :new
    end
  end

  def edit
    authorize! :update, @social_category
    @form = Panel::UpdateSocialCategoryForm.new(social_category_attributes)
  end

  def update
    @form = Panel::UpdateSocialCategoryForm.new(
        social_category_attributes,
        social_category_params
    )
    service = Panel::UpdateSocialCategoryService.new(@social_category, @form)

    if service.call
      redirect_to followings_panel_social_category_social_account_followings_path(@social_category), notice: _('Category was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    @social_category.destroy
    redirect_to panel_social_categories_path, notice: _('Category was successfully deleted.')
  end

  private
  def set_social_category
    @social_category = SocialCategory.find(params[:id])
  end

  def social_category_params
    params.require(:social_category_form).permit(:name, :image)
  end

  def social_category_attributes
    @social_category.slice(:name, :image)
  end

  def search_params
    params.permit(:search, :sort, :direction, :page)
  end

  def sort_column
    ['name'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def save_order_params
    params.permit(:ordered_ids)
  end
end
