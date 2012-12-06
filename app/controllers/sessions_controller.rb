class SessionsController < ApplicationController
  def new
  end

  def create

    auth_hash = request.env['omniauth.auth']
    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    #display container variable
    @wrapper_authorization = Hash.new
    if @authorization
      @wrapper_authorization["display"] = "Welcome back #{@authorization.user.name}! You have already signed up."
    else
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      user.save
      @wrapper_authorization["display"] = "Hi #{user.name}! You've signed up."
    end

    create_session (@authorization.user)
  end

  def create_session (user)
    #todo obviously bad practice to use email for this, just for testing, need to implement this properly
    remember_token = user.email
    cookies[:remember_token] = {value: remember_token,
                                expires: 20.years.from_now.utc}
    self.current_user = user

  end

  def failure
  end

  def destroy
    @cached_user_name = self.current_user.name
    session[:logged_in] = false
    session[:user_id] = nil
    @current_user = nil

    redirect_to :controller => 'companies', :action => 'index'
  end
end
