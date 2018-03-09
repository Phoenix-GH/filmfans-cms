class Api::V1::SocialAccountFollowingsController < Api::V1::BaseController
  def index
    if search_params[:trending] == 'true'
      page = search_params[:page] || 1
      if page.to_i > 1
        trending_followings = []
      else
        trending_followings = SocialAccountFollowingQuery.new(
            search_params,
            {distinct: false, ignore_paginate: true}
        ).results
      end


      all_followings = SocialAccountFollowingQuery.new(
          search_params.merge(trending: nil),
          distinct: search_params[:social_category_id].blank?
      ).results

      render json: {
          trendings: trending_followings.map { |following| SocialAccountFollowingSerializer.new(following).results },
          others: all_followings.map { |following| SocialAccountFollowingSerializer.new(following).results }
      }
    else
      followings = SocialAccountFollowingQuery.new(search_params.merge(trending: nil),
                                                   distinct: search_params[:social_category_id].blank?).results
      render json: followings.map { |following| SocialAccountFollowingSerializer.new(following).results }
    end
  end

  private
  def search_params
    params.permit(:search, :social_category_id, :trending, :page, :per)
  end
end
