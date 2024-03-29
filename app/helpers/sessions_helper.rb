module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def require_sign_in
    unless signed_in?
      store_location
      respond_to do |format|
        format.html { redirect_to signin_url, notice: "Please sign in." }
        format.json { render json: 'not signed in', status: :unprocessable_entity }
      end
    end
  end

  def require_not_signed_in
    if signed_in?
      respond_to do |format|
        format.html { redirect_to root_url, notice: "Already signed in" }
        format.json { render json: 'already signed in', status: :unprocessable_entity }
      end
    end
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end
end
