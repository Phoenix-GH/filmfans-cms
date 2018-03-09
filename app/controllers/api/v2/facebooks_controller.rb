class Api::V2::FacebooksController < Api::V2::OpenAuthsController
  def login
    super
  rescue Koala::Facebook::AuthenticationError => e
    LogHelper.log_exception e
    render json: {
        status: 'error',
        errors: [I18n.t("devise_token_auth.sessions.bad_credentials")]
    }, status: 401
  end

  protected
  def fetch_user_data
    @user_data = Api::V1::FbGraphUserDataFetcherService.new(params[:access_token]).call
  end

  def initialize_profile
    @profile = {
        name: @user_data['first_name'],
        surname: @user_data['last_name'],
        sex: parse_sex(@user_data['gender']),
        birthday: parse_birthday(@user_data['birthday']),
        picture: @user_data['encoded_image']
    }
  end

  private
  def parse_sex(value)
    if value
      if value.blank?
        return nil
      else
        if value.downcase == 'male' or value.downcase == 'female'
          return value.downcase
        else
          return nil
        end
      end
    else
      return nil
    end
  end

  def login_params
    params.permit(:access_token)
  end

  def parse_birthday(birthday)
    Date.strptime(birthday, '%m/%d/%Y').strftime('%Y/%m/%d') rescue nil
  end
end