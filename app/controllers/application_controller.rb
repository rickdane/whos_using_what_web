class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :set_mobile_preferences
  before_filter :redirect_to_mobile_if_applicable
  before_filter :prepend_view_path_if_mobile

  private

  def set_mobile_preferences
    if params[:mobile_site]
      cookies.delete(:prefer_full_site)
    elsif params[:full_site]
      cookies.permanent[:prefer_full_site] = 1
      redirect_to_full_site if mobile_request?
    end
  end

  def prepend_view_path_if_mobile
    if mobile_request?
      prepend_view_path Rails.root + 'app' + 'mobile_views'
    end
  end

  def redirect_to_full_site
    redirect_to request.referer.gsub(/m\./, '') and return
  end

  def redirect_to_mobile_if_applicable
    unless mobile_request? || cookies[:prefer_full_site] || !mobile_browser?
      redirect_to request.protocol + "m." + request.host_with_port.gsub(/^www\./, '') +
                      request.request_uri and return
    end
  end

  def mobile_request?
    #hack for local testing to check reglar domain too
    request.subdomains.first == 'm' || request.domain.first == 'm'
  end

  helper_method :mobile_request?

  def mobile_browser?
    request.env["HTTP_USER_AGENT"] && request.env["HTTP_USER_AGENT"][/(iPhone|iPod|iPad|Android)/]
  end

  helper_method :mobile_browser?
end
