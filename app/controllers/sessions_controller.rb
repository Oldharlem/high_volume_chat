class SessionsController < ApplicationController
  skip_before_action :require_user

  def new
    @users = User.all
  end

  def create
    user = User.find(params[:user_id])
    session[:user_id] = user.id
    redirect_to root_path, notice: "Welcome back, #{user.name}!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: "Successfully logged out"
  end
end 