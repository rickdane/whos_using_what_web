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
    #hack for request.domain in case issue with subdomain
    request.subdomains.first == 'm' || request.domain.first == 'm'
  end

  helper_method :mobile_request?

  def mobile_browser?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android)/]
  end

  helper_method :mobile_browser?


  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    user_signed_in?
  end

  helper_method :current_user, :signed_in?

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
    session[:logged_in] = true
  end

end
