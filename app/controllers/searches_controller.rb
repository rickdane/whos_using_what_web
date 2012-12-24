require 'whos_using_what/api_clients/linkedin_client'
require_relative '../nosql/mongo_helper'
require 'whos_using_what/data_searchers/companies_searcher'
require 'whos_using_what/data_gatherers/geo_tagger'

#only for testing


class SearchesController < ApplicationController

  layout 'searches'

  before_filter :authenticate_user!

  def authenticate_user!

    signed_in = signed_in?

    if !signed_in

      redirect_to "/authenticate"
    end

    signed_in

  end

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


  def new

    @search = Search.new

    render :template => "searches/new"

  end


  def search

    #------- just for testing
    log = LoggerFactory.get_default_logger

    geo_tagger = GeoTagger.new log
    gather_companies = GatherCompanies.new
    companies_searcher = CompaniesSearcher.new geo_tagger
    near = companies_searcher.zip_code_search "95688"
    #-------


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
