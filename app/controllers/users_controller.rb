class UsersController < ApplicationController
  before_filter :find_user, only: [:show, :edit, :update, :destroy]
  before_filter :require_sign_in, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update, :destroy]
  before_filter :require_not_signed_in, only: [:new, :create]

  # url: users_url
  # GET /users
  # GET /users.json
  def index
    case params[:relationship] ||= 'following'
    when 'following'
      @users = current_user.following_users
    when 'followers'
      @users = current_user.followers
    when 'followers-following'
      @users = current_user.followers & current_user.following_users
    when 'public'
      @users = User.find_all_by_privacy_level "public"
    end

    respond_to do |format|
      format.html # index.html.haml
      format.json { render json: @users }
    end
  end

  # url: show_user_url(user)
  # GET /users/:id
  # GET /users/:id.json
  def show
    respond_to do |format|
      format.html # show.html.haml
      format.json { render json: @user }
    end
  end

  # url: new_user_url
  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.haml
      format.json { render json: @user }
    end
  end

  # url: edit_user_url(user)
  # GET /users/:id/edit
  def edit
  end

  # no url or path, this is only from forms
  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        sign_in @user
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # no url or path, this is only from forms
  # PUT /users/:id
  # PUT /users/:id.json
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # no url or path, this is only from forms
  # DELETE /users/:id
  # DELETE /users/:id.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end


  private

  def find_user
    @user ||= User.find params[:id]
  end

  def correct_user
    find_user unless @user
    redirect_to(root_url) unless current_user?(@user)
  end
end
