class SessionsController < ApplicationController

  def new

    render :template => "sessions/new"

  end

  def create_db_session_helper user, auth_hash

    #set permissions scope
    request.env['omniauth.strategy'].options[:scope] = "r_basicprofile r_emailaddress r_network"

    credentials_linkedin = {
        :token => auth_hash['credentials']['token'],
        :secret => auth_hash['credentials']['secret']
    }

    user_doc = @@users_collection.find_one(:session_id => session[:session_id])
    if user_doc == nil
      user_doc = {:session_id => session[:session_id],
                  :active => true,
                  :user => {
                      :email => user.email
                  },
                  :credentials_linkedin => credentials_linkedin}
      @@users_collection.insert(user_doc)
    else
      # TODO this logic may need to be re-visited
      @@users_collection.update({"_id" => user_doc['_id']}, {"$set" => {:active => true}})
    end

  end


  def loginstatus

    render :json => signed_in?

  end


  def show


  end


  def destroy

    cookies[:_whos_using_what_web_session] = nil

    @@users_collection.remove(:session_id => session[:session_id])

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

    #todo: in process of potentially removing devise completely as am using custom login functionality
    #sign_in_and_redirect(:user, user)

    create_db_session_helper user, auth_hash

    redirect_to "/"

  end

  def failure


  end

end
