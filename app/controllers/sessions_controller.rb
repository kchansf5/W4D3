class SessionsController < ApplicationController

  before_action :require_log_out, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    user = User.find_by_credentials(
      params[:user][:username],
      params[:user][:password])

    if user.nil?
      flash[:errors] = ['Invalid credentials']
      redirect_to new_session_url
    else
      login!(user)
      redirect_to :root
    end
  end

  def destroy
    logout!
    redirect_to new_session_url
  end

end
