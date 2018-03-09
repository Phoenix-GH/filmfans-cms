class SocialCategoryQuery < BaseQuery
  def initialize(*)
    super
  end

  def results
    prepare_query
    filter_top_categories
    if filters[:is_top]
      order_results(:position, :desc)
    else
      order_results(:is_top, :desc)
      order_results(:position, :desc)
    end
    paginate_result

    @results
  end

  private

  def filter_top_categories
    return if filters[:is_top].nil?
    is_top = filters[:is_top]
    if is_top
      @results = @results.where(is_top: is_top).includes([:social_account_following_categories, :social_account_followings])
    else
      @results = @results.where(is_top: is_top)
    end
  end

  def prepare_query
    @results = SocialCategory.all
  end
end
