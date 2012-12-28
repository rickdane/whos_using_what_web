require 'whos_using_what/api_clients/linkedin_client'
require_relative '../nosql/mongo_helper'
require 'whos_using_what/data_searchers/companies_searcher'
require 'whos_using_what/data_gatherers/geo_tagger'
require_relative '../models/person_search'


class SearchesController < ApplicationController

  layout 'searches'

  before_filter :authenticate_user!

  def init

    @mongo_client = MongoHelper.get_mongo_connection
    @companies_coll = @mongo_client['companies']
    @coords_coll = @mongo_client['coordinates']
  end

  def authenticate_user!

    # TOOD this is a hack, re-factor
    init

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

    @person_search = PersonSearch.new

    render :template => "searches/new"

  end


  def search

    # TODO this is being called twice when search form is submitted, once as POST and once as GET, figure out why and fix this, as it should only call as POST

    @person_search = params[:person_search]
    @results = Array.new

    @req_zip = @person_search[:zipcode]
    @req_prog_language = @person_search[:programming_language]

    cur_user = @@users_collection.find_one(:session_id => session[:session_id])

    # TODO need to provide validation of zip input field (implement at model level)
    coords = @coords_coll.find_one({
                                       :zip => @req_zip
                                   })
    if coords == nil
      # TODO need to have "no results display option for this case"
      render 'searches/search_results'
    end

    # create the linkedin client that is specific to the user TODO see about keeping this cached within session
    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], cur_user['credentials_linkedin']['token'], cur_user['credentials_linkedin']['secret'], "http://linkedin.com")

    # perform geo-location company search
    nearby_companies = @companies_coll.find({"loc" => {"$near" => [coords['loc']['lat'], coords['loc']['lon']]}}).limit(10)

    #TODO need to rework to use facet linkedin search from client as can't make this many calls for 1 search (due to threshold limits)
=begin
    nearby_companies.each do |nearby_company|
      container = {
          :company => {
              :name => nearby_company['name'],
              :url => nearby_company['websiteUrl'],
              :logo_url => nearby_company['logoUrl'],
              :loc => nearby_company['loc']
          },
          :people => []
      }
      raw_results = @linkedin_client.query_people_from_company nearby_company['name'], coords['city'] << ", " << coords['state']
      people = raw_results['people']['values']

      if !people
        next
      end

      limit = 3
      iter = 1
      people.each do |person|
        if iter > limit
          break
        end


        container[:people].push person

        iter += iter
      end

      @results.push container

    end
=end

    render 'searches/search_results'

  end

end
