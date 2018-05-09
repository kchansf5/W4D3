class SessionsController < ApplicationController

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
      user.reset_session_token!
      session[:session_token] = user.session_token
      redirect_to :root
    end
  end

  def destroy
  end

end
