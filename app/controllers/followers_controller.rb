class FollowersController < ApplicationController
  before_filter :require_sign_in

  respond_to :html, :json

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
    @user = User.find params[:id]
    if !current_user.following?(@user) and !current_user.is_ignoring_follows_from(@user)
      current_user.follow @user
      if @user.public?
        @user.accept_follower current_user
        flash.now[:success] = "Successfully followed #{@user.nickname}"
      end
    else
      flash.now[:success] = "Requested to follow #{@user.nickname}"
    end
    respond_with @user
  end

  def destroy
    @user = User.find params[:id]
    current_user.stop_following(@user)
    respond_with @user
  end

  def accept
    @user = User.find params[:id]
    unless current_user.following? @user
      current_user.accept_follower @user
      flash.now[:success] = "Successfully accepted #{@user.nickname}'s follow request"
    else
      flash.now[:notice] = "Already following #{@user.nickname}"
    end
    respond_with @user
  end

  def block
    @user = User.find params[:id]
    current_user.block @user
    flash.now[:success] = "Blocked #{@user.nickname}"
    respond_with @user
  end

  def ignore
    @user = User.find params[:id]
    if current_user.has_pending_follow_request_from @user
      current_user.ignore_follower @user
      flash.now[:success] = "Ignored #{@user.nickname}'s follow request"
    else
      flash.now[:error] = "Unable to find follow request from #{@user.nickname}."
    end
    respond_with @user
  end

  def decline
    @user = User.find params[:id]
    if current_user.has_pending_follow_request_from @user
      current_user.decline_follower @user
      flash.now[:success] = "Declined #{@user.nickname}'s follow request"
    else
      flash.now[:error] = "Unable to find follow request from #{@user.nickname}"
    end
    respond_with @user
  end
end
