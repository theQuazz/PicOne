class Api::V1::FollowersController < ApiController

  before_filter :find_user, only: [:create, :destroy, :accept, :block, :ignore, :decline]

  def following
    respond_with current_user.all_following
  end

  def index
    respond_with current_user.followers
  end

  def pending
    respond_with current_user.pending_followers
  end

  def ignored
    respond_with current_user.ignored_followers
  end

  def blocked
    respond_with current_user.blocks
  end

  def create
    if !current_user.following?(@user) and !current_user.is_ignoring_follows_from(@user)
      current_user.follow @user
      if @user.public?
        @user.accept_follower current_user
      end
    end
    respond_with @user
  end

  def destroy
    current_user.stop_following(@user)
    respond_with @user
  end

  def accept
    current_user.accept_follower(@user) unless current_user.following?(@user)
    respond_with @user
  end

  def block
    current_user.block @user
    respond_with @user
  end

  def ignore
    if current_user.has_pending_follow_request_from @user
      current_user.ignore_follower @user
    end
    respond_with @user
  end

  def decline
    if current_user.has_pending_follow_request_from @user
      current_user.decline_follower @user
    end
    respond_with @user
  end

  private

  def find_user
    @user = User.find params[:id]
  end

end
