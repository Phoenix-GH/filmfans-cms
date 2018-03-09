class Api::V1::SocialUserFolloweesController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!, only: [:index, :delete_multi, :create_multi]
  before_action :set_snapped_photo, only: [:destroy]

  def index
    followees = current_api_v1_user.social_account_followings
    whitelist_attrs = followees.column_names.reject { |n| n == "tsv" }
    followees = followees.select(whitelist_attrs)

    render json: followees
  end

  def create_multi
    unless params[:ids].nil? || params[:ids].empty?
      new_ids = params[:ids] - current_api_v1_user.social_account_followings.select(:id).map(&:id)
      current_api_v1_user.social_account_followings << SocialAccountFollowing.where(id: new_ids) unless new_ids.empty?
    end

    render nothing: true, status: 200
  end

  def delete_multi
    unless params[:ids].nil? || params[:ids].empty?
      targets = SocialUserFollowee.where(user_id: current_api_v1_user.id,
                                         social_account_following_id: params[:ids])

      # destroy 1by1 for trigger model callbacks
      current_api_v1_user.social_user_followees.destroy(targets)
    end
    render nothing: true, status: 200
  end
end
