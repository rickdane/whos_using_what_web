require 'whos_using_what/linkedin_client'
#require_relative '../nosql/mongo_helper'

class SearchesController < ApplicationController

  layout 'searches'

  # before_filter :initial_filter
  before_filter :authenticate_user! #:except => [:some_action_without_auth]
                                    # Access Current User

  def initialize

    super

    unless Rails.env.production?
      @config = YAML.load_file(File.expand_path("../../../config/keys.env", __FILE__))
      ENV["linkedin.api_key"]= @config["linkedin.api_key"]
      ENV["linkedin.api_secret"] = @config["linkedin.api_secret"]
      ENV["linkedin.user_token"] = @config["linkedin.user_token"]
      ENV["linkedin.user_secret"]= @config["linkedin.user_secret"]
    end

  end

  #todo make this as mix-in method for use in other controllers
  def initial_filter
    @cur_view_user = Hash.new

    logged_in = session[:logged_in]

    if  logged_in == nil
      logged_in = false
      #todo figure out how to use template here
    elsif logged_in
      #todo remove any sensitive data from view layer user object after clone
      @cur_view_user["user"] = self.current_user.clone
    end
    @cur_view_user["logged_in"] = logged_in

  end

  def get_people_for_company


  end


  def new

    #MongoHelper.get_connection
   # @search = Search.new

  end


  def search
    @search = Search.new(params[:search])
    @results = Array.new

    #todo grab user info to verify linkedin
    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], ENV["linkedin.user_token"], ENV["linkedin.user_secret"], "http://linkedin.com")

    #mock results
    @results.push("some company")
    @results.push("another company")

    puts "search query is: " + @search.name

    render 'searches/search_results'
  end

end
