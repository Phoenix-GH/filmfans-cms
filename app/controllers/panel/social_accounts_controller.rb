class Panel::SocialAccountsController < Panel::BaseController
  before_action :set_social_account, only: [:edit, :update, :destroy]

  def index
    @social_accounts = SocialAccountQuery.new(search_params).results
  end

  def new
    @form = Panel::CreateSocialAccountForm.new
  end

  def create
    @form = Panel::CreateSocialAccountForm.new(social_account_params)
    service = Panel::CreateSocialAccountService.new(@form)

    if service.call
      RestClient.get("#{ENV['CRAWLER_URL']}/login?username=#{@form.attributes[:username]}") { |res|
        @responseMsg = JSON.parse(res.body)
        if not @responseMsg['errorLogin'].blank?
          @errMsg = @responseMsg['errorLogin']['errorMessage']
          if @responseMsg['errorLogin']['errorCode'] == 400
            @errMsg = 'The crawler cannot login to this account because Instagram needs you to verify the account.
                        Please login to Instagram account in order to verify it'
          end
          flash[:alert] = _(@errMsg)
        end
      }
      redirect_to panel_social_accounts_path, notice: _('Social Account was successfully created.')
    else
      render :new
    end
  end

  def edit
    @form = Panel::UpdateSocialAccountForm.new(social_account_attributes)
  end

  def update
    @form = Panel::UpdateSocialAccountForm.new(
        social_account_attributes,
        social_account_params
    )
    service = Panel::UpdateSocialAccountService.new(@social_account, @form)

    if service.call
      RestClient.get("#{ENV['CRAWLER_URL']}/login?username=#{@form.attributes[:username]}") { |res|
        @responseMsg = JSON.parse(res.body)
        if not @responseMsg['errorLogin'].blank?
          @errMsg = @responseMsg['errorLogin']['errorMessage']
          if @responseMsg['errorLogin']['errorCode'] == 400
            @errMsg = 'The crawler cannot login to this account because Instagram needs you to verify the account.
                        Please login to Instagram account in order to verify it'
          end
          flash[:alert] = _(@errMsg)
        end
      }
      redirect_to panel_social_accounts_path, notice: _('Social Account was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    @social_account.destroy
    redirect_to panel_social_accounts_path, notice: _('Social Account was successfully deleted.')
  end

  private
  def set_social_account
    @social_account = SocialAccount.find(params[:id])
  end

  def social_account_params
    params.require(:social_account_form).permit(:name, :username, :password, :password_confirmation, :provider)
  end

  def social_account_attributes
    @social_account.slice(:name, :username, :password, :provider)
  end

  def search_params
    params.permit(:search, :sort, :direction, :page)
  end

  def sort_column
    ['name', 'username', 'provider', 'social_account_followings'].include?(params[:sort]) ? params[:sort] : 'id'
  end
end