class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :not_owner?, :owner?

  def current_user
    return nil if session[:session_token] == nil
    @current_user ||= User.find_by_session_token(session[:session_token])
  end

  def login!(user)
    @current_user = user
    session[:session_token] = user.reset_session_token!
  end

  def logout!
    current_user.reset_session_token!
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def require_log_out
    redirect_to cats_url if logged_in?
  end

  def require_log_in
    redirect_to new_session_url unless logged_in?
  end

  def not_owner?(id = params[:id])
    current_user.cats.where(id: id).empty?
  end

  def owner?
    !not_owner?
  end

end
