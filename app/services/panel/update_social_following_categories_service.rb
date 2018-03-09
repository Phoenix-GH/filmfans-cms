class Panel::UpdateSocialFollowingCategoriesService
  def initialize(following, form)
    @following = following
    @form = form
  end

  def call
    return false unless @form.valid?
    update
  end

  private

  def update
    social_category_ids = @form.attributes[:social_category_ids].reject { |c| c.empty? }
    social_category_ids = social_category_ids.map {|c|
      [
          {
              social_category_id: c
          }
      ]
    }

    @following.social_account_following_categories.destroy_all
    @following.social_account_following_categories.create(social_category_ids)
  end
end
