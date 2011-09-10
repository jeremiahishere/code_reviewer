class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :redirect_if_logged_in

  # if the user is set and the url is set, redirect to it
  # unset th url so hopefully we don't get in a loop
  # 
  # this should trigger once when a user logs in and never again
  # hopefully
  def redirect_if_logged_in
    if current_user && session[:url_on_missing_user_session]
      url = session[:url_on_missing_user_session]
      session[:url_on_missing_user_session] = nil
      redirect_to url
    end
  end

  # on a cancan error, redirect to root if the user is logged in
  # if there is no user logged in, save the url and redirect to the login page
  rescue_from CanCan::AccessDenied do |exception|
    if !current_user
      session[:url_on_missing_user_session] = request.request_uri
      redirect_to new_user_session_path, :alert => exception.message
    else
      redirect_to root_url, :alert => exception.message
    end
  end
end
