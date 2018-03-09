class Api::V1::SocialCategoriesController < Api::V1::BaseController
  def index
    social_categories_top = SocialCategoryQuery.new(search_params.merge({is_top: true})).results
    social_categories = SocialCategoryQuery.new(search_params.merge({is_top: false})).results
    render json: SocialCategorySerializer.new(social_categories_top, social_categories).results
  end

  private
  def search_params
    params.permit(:search, :page, :per)
  end
end
