class Panel::SocialAccountFollowingsController < Panel::BaseController
  before_action :set_social_account, except: [:followings, :save_order, :save_order_top, :toggle_trending]
  before_action :set_following, only: [:edit_categories, :update_categories]
  before_action :set_social_categories, only: [:index, :edit_categories]
  before_action :set_social_category, only: [:followings, :save_order, :save_order_top]
  before_action :set_social_following_category, only: [:toggle_trending]

  def index
    @followings = SocialAccountFollowingQuery.new(search_params).results
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
      redirect_to panel_social_account_followings_path(@social_account), notice: _('Linked social categories was successfully updated.')
    else
      redirect_to panel_social_account_followings_path(@social_account), alert: _('Failed to update linked social categories.')
    end
  end

  # this is a nesting resource of social category
  # its params should be in a category context
  def followings
    @has_search = followings_params.select do |k,v|
      [:search, :social_account_name].map(&:to_s).include?(k) &&
        !v.blank?
    end.keys.length > 0
    @page = followings_params[:page]
    @followings = SocialAccountFollowingQuery.new(followings_params.merge({:social_category_id => @social_category.id}), select: "social_account_followings.*, social_account_following_categories.id AS main_id, social_accounts.name AS social_account_name").results
  end

  def save_order
    target = SocialAccountFollowingCategory.where(social_category_id: @social_category.id)
    service = Panel::UpdatePositionService.new(target, order_params[:ordered_ids], page: page_i, per: order_params[:per])

    if service.call
      redirect_to followings_panel_social_category_social_account_followings_path(@social_category), notice: _('Followings was successfully sorted.')
    else
      redirect_to followings_panel_social_category_social_account_followings_path(@social_category), notice: _('Failed to sort followings.')
    end
  end

  def save_order_top
    target = SocialAccountFollowingCategory.find(params[:id])
    target.position = SocialAccountFollowingCategory.where(social_category_id: @social_category.id).minimum("position").to_i - 1 # to_i force nil->0
    if target.save
      redirect_to followings_panel_social_category_social_account_followings_path(@social_category), notice: _('Followings was successfully sorted.')
    else
      redirect_to followings_panel_social_category_social_account_followings_path(@social_category), notice: _('Failed to sort followings.')
    end
  end

  def toggle_trending
    service = Panel::ToggleService.new(@social_following_category, :trending)
    service.call

    respond_to do |format|
      format.js do
        render layout: false
      end
    end
  end

  private
  def set_social_account
    @social_account = SocialAccount.find(params[:social_account_id])
  end

  def set_following
    @following = SocialAccountFollowing.find(params[:id])
  end

  def set_social_categories
    @social_categories = SocialCategory.all.map { |category|
      [category.name, category.id]
    }
    @selected_category = search_params[:social_category]
  end

  def social_following_categories_params
    params.require(:social_following_categories_form).permit(:social_category_ids => [])
  end

  def social_following_categories_attributes
    {
        social_category_ids: []
    }
  end

  def set_social_following_category
    @social_following_category = SocialAccountFollowingCategory.where(
        social_category_id: params[:social_category_id],
        social_account_following_id: params[:social_account_following_id]
    ).first
  end

  def search_params
    params.permit(:social_category, :search, :sort, :direction, :page, :per).merge(social_account_id: @social_account.id)
  end

  def sort_column
    ['name', 'target_id'].include?(params[:sort]) ? params[:sort] : 'id'
  end

  def followings_params
    params.permit(:search, :sort, :direction, :page, :per, :social_category_id, :social_account_name)
  end

  def set_social_category
    @social_category = SocialCategory.find(params[:social_category_id])
  end

  def order_params
    params.permit(:ordered_ids, :page, :per, :social_category_id)
  end

  def page_i
    page = order_params[:page].to_i
    page <= 0 ? 1 : page
  end
end
