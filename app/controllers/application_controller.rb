class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery


  #for mobile version of app
  before_filter :prepend_view_path_if_mobile

  private

  #for mobile version of app
  def prepend_view_path_if_mobile
    if mobile_request?
      prepend_view_path Rails.root + 'app' + 'mobile_views'
    end
  end

  #for mobile version of app
  def mobile_request?
    request.subdomains.first == 'm'
  end

  helper_method :mobile_request?


  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
    session[:logged_in] = true
  end

end
