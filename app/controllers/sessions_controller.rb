class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_nickname(params[:session][:nickname]) || User.find_by_email(params[:session][:email])
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        sign_in user
        format.html { redirect_back_or user }
        format.json { render json: true }
      else
        format.html { render 'new', notice: 'Invalid login combination' }
        format.json { render json: false }
      end
    end
  end

  def destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { render json: true }
    end
  end
end