class UserSerializer
  def initialize(user)
    @user = user
  end

  def results
    return {} unless @user

    generate_user_json
    add_profile_info
  end

  private
  def generate_user_json
    @user_json = {
      id: @user.id,
      provider: @user.provider,
      uid: @user.uid,
      email: @user.email,
      created_at: @user.created_at,
      updated_at: @user.updated_at,
      ulab_user_id: @user.ulab_user_id,
      ulab_access_token: @user.ulab_access_token
    }
  end

  def add_profile_info
    @user_json.merge!(ProfileSerializer.new(@user.profile).results)
  end
end
