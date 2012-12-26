class SessionsController < ApplicationController

  def new

    render :template => "sessions/new"

  end

  def create_session (user)

    resp_doc = @@collection.find_one(:session_id => session[:session_id])
    if resp_doc == nil
      doc = {:session_id => session[:session_id],
             :active => true,
             :user => {
                 :email => user.email
             }}
      @@collection.insert(doc)
    else
      # TODO this logic may need to be re-visited
      @@collection.update({"_id" => resp_doc[0][1]}, {"$set" => {:active => true}})
    end


  end


  def loginstatus

    render :json => signed_in?

  end


  def show


  end


  def destroy

    cookies[:_whos_using_what_web_session] = nil

    @@collection.remove(:session_id => session[:session_id])

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
      user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"], :scope => "r_basicprofile+r_emailaddress+r_network"
      if user.save :validate => false
        #user was created
      else
        #redirect to try again
      end

    end

    #todo: in process of potentially removing devise completely as am using custom login functionality
    #sign_in_and_redirect(:user, user)

    create_session (user)

    redirect_to "/"

  end

  def failure


  end

end
