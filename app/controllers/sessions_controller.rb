class SessionsController < ApplicationController
  def new
  end

  def create_session (user)
    #todo obviously bad practice to use email for this, just for testing, need to implement this properly
    remember_token = user.email
    cookies[:remember_token] = {value: remember_token,
                                expires: 20.years.from_now.utc}
    auths = Authorization.find_all_by_user_id user.id
    self.current_user = user

  end

  def create

    #important to call this to render any other sessions for user invalid
    reset_session

    auth_hash = request.env['omniauth.auth']

    @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    #display container variable

    if @authorization
      user = @authorization.user
    else
      user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
      if user.save :validate => false
        #user was created
      else
        #redirect to try again
      end
    end

    #this is what actually enables the  before_filter :authenticate_user! to work in the controllers
    user.apply_omniauth(auth_hash)

    create_session (user)

    sign_in_and_redirect(:user, user)
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
