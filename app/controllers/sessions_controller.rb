class SessionsController < ApplicationController

  def new

    render :template => "sessions/new"

  end

  def create_session (user)

    #todo shouldn't store entire user object, need to re-work this
    cookies[:user_data] = {value: user,
                           expires: 20.years.from_now.utc}
    auths = Authorization.find_all_by_user_id user.id


    arr = @@collection.find_one(@session_key => "true").to_a
    puts "--create, attempting to find session with key of: " + @session_key

    arrfalse = @@collection.find_one(@session_key => "false").to_a
    if arr.size < 1 && arrfalse.size < 1
      @@collection.insert({@session_key => "true"})
    else

      @@collection.update({"_id" => arr[0][1]}, {"$set" => {@session_key => "true"}})
      # @@collection.update(session[:session_id], "true")
    end


  end

  def self.create_session_custom
    arr = @@collection.find_one(@session_key => "true").to_a

    arrfalse = @@collection.find_one(@session_key => "false").to_a
    if arr.size < 1 && arrfalse.size < 1
      @@collection.insert({@session_key => "true"})
    else

      @@collection.update({"_id" => arr[0][1]}, {"$set" => {@session_key => "true"}})
      # @@collection.update(session[:session_id], "true")
    end
  end

  def loginstatus

    render :json => user_signed_in?

  end


  def show


  end


  def destroy

    cookies[:user_data] = nil
    cookies[:_whos_using_what_web_session] = nil

    #for new nosql session functionality
    arr = @@collection.find_one(session[:session_id] => "true").to_a
    if arr.size >1
      @@collection.update({"_id" => arr[0][1]}, {"$set" => {session[:session_id] => "false"}})
    end

    reset_session

    redirect_to "/authenticate"

  end


  def create

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
    #todo, this is broken
    user.apply_omniauth(auth_hash)


    #sign_in_and_redirect(:user, user)

    create_session (user)

  end

  def failure


  end

end
