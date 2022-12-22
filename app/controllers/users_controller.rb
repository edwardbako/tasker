class UsersController < ApplicationController
  def index
    set_users
  end

  def show
    @user = User.find(params[:id])
    set_users
    render :index
  end

  private

  def set_users
    @users = User.where.not(id: current_user)
  end

end