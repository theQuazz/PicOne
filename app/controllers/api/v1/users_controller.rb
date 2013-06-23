class Api::V1::UsersController < ApiController

  skip_before_filter :token_authenticate, only: :create

  before_filter :find_user, only: [:show, :update, :destroy]
  before_filter :correct_user, only: [:update, :destroy]

  def index
    @users = User.find_all_by_privacy_level "public"

    respond_with @users
  end

  def show
    @user = User.find params[:id]

    if current_user?(@user) || @user.public?
      respond_with @user
    else
      respond_with { errors: ['Not authorized to view user'] }, status: :unauthorized
    end
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to api_v2_user_path(@user)
    else
      respond_with { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update_attributes(user_params)
      head :no_content
    else
      respond_with { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy

    head :no_content
  end

  private

  def find_user
    @user ||= User.find params[:id]
  end

  def correct_user
    find_user unless @user
    raise_not_authorized unless current_user == @user
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :nickname, :email, :password, :password_confirmation)
  end

end
