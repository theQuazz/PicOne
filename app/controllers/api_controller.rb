class ApiController < ActionController::Base
  respond_to :json

  attr_accessor :current_user

  before_filter :token_authenticate

  def raise_not_authorized
    render json: { errors: ['Not authorized'] }, status: :unauthorized
  end

  private

  def token_authenticate
    authenticate_or_request_with_http_token do |token, options|
      current_user = User.for_access_token(token)
    end
  end

end
