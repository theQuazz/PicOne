class Web::SessionsController < WebController
  respond_to :html

  def create
    @user = User.find_by_nickname_or_email(params[:session][:login])
    if @user && @user.authenticate(params[:session][:password])
      sign_in @user
      redirect_back_or @user
    else
      render 'new', notice: 'Invalid login combination'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
