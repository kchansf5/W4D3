class UsersController < ApplicationController

  before_action :require_log_out, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    user = User.new(user_params)
    if user.save
      login!(user)
      redirect_to cats_url
    else
      flash[:errors] = ['Invalid credentials']
      redirect_to new_user_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end
end
