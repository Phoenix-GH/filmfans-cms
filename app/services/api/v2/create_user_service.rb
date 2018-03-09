class Api::V2::CreateUserService
  class CreateUserProfileFailed < ActiveRecord::WrappedDatabaseException

  end

  def initialize(user, profile_form)
    @user = user
    @profile_form = profile_form
  end

  def call
    ActiveRecord::Base.transaction do
      begin
        if @user.save
          # Create user success, add new user profile info
          service = Api::V1::UpdateUserProfileService.new(@user, @profile_form)

          if service.call
            return true
          else
            raise CreateUserProfileFailed.new("Create user profile failed")
          end
        else
          return false
        end
      rescue ActiveRecord::RecordNotUnique => e
        # raise the exception for rails to rollback the transaction
        raise e
      end
    end
  end
end