class ApplicationController < ActionController::Base
  layout "application"
  protect_from_forgery

  @@mongo = nil

  def initialize
    super
    if @@mongo == nil
      @@mongo = MongoHelper.get_connection
      @@collection = @@mongo['users']
    end
  end

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
    return session[:current_user]
  end

  def signed_in?

    arr = @@collection.find_one(session[:session_id] => "true").to_a
    if arr.size < 1
      return false
    else
      return true
    end

  end


  helper_method :current_user, :signed_in?

  #todo see about getting ride of this as this seems to duplicate purpose of another method
  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
    session[:logged_in] = true
  end


end
