class Api::V1::AuthenticationsController < ApiController
  respond_to :json
  skip_before_filter :token_authenticate

  def create
    @user = User.find_by_email_or_nickname params[:credentials][:uid]

    if @user.authenticate params[:credentials][:password]
      @user.api_keys.create
      respond_with { access_token: @user.current_access_token }
    else
      respond_with { errors: ['Bad credentials'] }, status: :unauthorized
    end
  end

  def raise_not_authorized
    render json: { errors: ['Not authorized'] }, status: :unauthorized
  end

end
