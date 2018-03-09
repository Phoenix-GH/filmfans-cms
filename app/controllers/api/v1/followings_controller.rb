class Api::V1::FollowingsController < Api::V1::BaseController
  before_action :authenticate_api_v1_user!

  def toggle
    form = Panel::ToggleFollowingForm.new(followings_params.merge(user_id: current_api_v1_user.id))
    service = Panel::ToggleFollowingService.new(form)

    if service.call
      serializer = FollowingSerializer.new(current_api_v1_user, service.followed)

      render json:  serializer.results
    else
      render json: form.errors.full_messages, status: 400
    end
  end

  private

  def followings_params
    params.permit(:followed_id, :followed_type)
  end
end
