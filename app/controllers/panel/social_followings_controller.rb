class Panel::SocialFollowingsController < Panel::BaseController
  before_action :set_following, only: [:edit_categories, :update_categories]
  before_action :set_social_categories, only: [:index, :edit_categories]
  before_action :set_search_params, only: [:index, :edit_categories, :update_categories]

  def index
    @followings = SocialAccountFollowingQuery.new(search_params, {eager_load: [:social_account_following_categories, :social_categories, :social_account]}).results
    @presenter = SocialFollowingPresenter.new
  end

  def edit_categories
    @form = Panel::UpdateSocialFollowingCategoriesForm.new(social_following_categories_attributes)
    @selected_category_ids = @following.social_categories.map(&:id)

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  def update_categories
    @form = Panel::UpdateSocialFollowingCategoriesForm.new(
        social_following_categories_attributes,
        social_following_categories_params
    )

    service = Panel::UpdateSocialFollowingCategoriesService.new(@following, @form)

    if service.call
      redirect_to panel_social_followings_path(search_params), notice: _('Linked social categories was successfully updated.')
    else
      redirect_to panel_social_followings_path(search_params), alert: _('Failed to update linked social categories.')
    end
  end

  private
  def set_following
    @following = SocialAccountFollowing.find(params[:id])
  end

  def set_social_categories
    @social_categories = SocialCategory.all.map { |category|
      [category.name, category.id]
    }
    @selected_category = search_params[:social_category]
  end

  def set_search_params
    @search_params = search_params
  end

  def social_following_categories_params
    params.require(:social_following_categories_form).permit(:social_category_ids => [])
  end

  def social_following_categories_attributes
    {
        social_category_ids: []
    }
  end

  def search_params
    params.permit(:social_category, :search, :social_account_name, :sort, :direction, :page, :per, :social_category_id)
  end

  def sort_column
    ['name', 'social_account.name' 'target_id'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end
