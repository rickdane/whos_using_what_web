require 'whos_using_what/api_clients/linkedin_client'
require 'whos_using_what/api_clients/simply_hired_client'
require_relative '../nosql/mongo_helper'
require 'whos_using_what/data_searchers/companies_searcher'
require 'whos_using_what/data_gatherers/geo_tagger'
require_relative '../models/person_search'
require_relative '../../app/api_utils/linkedin_api_util'


class SearchesController < ApplicationController

  include LinkedinApiUtil

  layout 'searches'

  before_filter :authenticate_user!

  def init

    @mongo_client = MongoHelper.get_mongo_connection
    @companies_coll = @mongo_client['companies']
    @coords_coll = @mongo_client['coordinates']
    @simply_hired_client = SimplyHiredClient.new

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

  def clean_company_name_helper input_name

    #remove spaces
    company_name = input_name.gsub(/\s+/, "")
    company_name.downcase!

  end

  #determines if result has already appeared so we don't repeate results
  def is_result_dupe? result

    if !@results_dedupe_map
      @results_dedupe_map = []
    end

    if result.size > 100
      result = result[0..99]
    end

    result.downcase!
    result = result.gsub(/\s+/, "")

    if @results_dedupe_map.include? result
      return true
    end

    @results_dedupe_map.push result

    false

  end

  def prepare_for_url_helper input

    input = input.gsub(/\s+/, "+")

  end

  def search

    # TODO this is being called twice when search form is submitted, once as POST and once as GET, figure out why and fix this, as it should only call as POST

    cur_user = @@users_collection.find_one(:session_id => session[:session_id])

    # create the linkedin client that is specific to the user TODO see about keeping this cached within session
    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], cur_user['credentials_linkedin']['token'], cur_user['credentials_linkedin']['secret'], "http://linkedin.com")

    @person_search = params[:person_search]

    @req_zip = @person_search[:zipcode]
    @req_prog_language = @person_search[:programming_language]

    @results = Array.new

    xml_resp = @simply_hired_client.perform_search @req_prog_language, "san francisco, ca"

    company_containers = Hash.new
    company_names = []

    job_listings = xml_resp['shrs']['rs']['r']

    job_listings.each do |job|

      #skip if its a dupe
      # TODO verify whether this is necessary
      if is_result_dupe? job['e']
        next
      end

      if !job['cn'].is_a? String
        next
      end

      company_name_clean = clean_company_name_helper job['cn']

      container = company_containers[company_name_clean]

      url = job['src'].attributes["url"]

      job_map = {
          :title => job['jt'],
          :location => job['loc'],
          :description => job['e'],
          :url => url
      }

      if !container
        company_names.push company_name_clean
        url_company_name = prepare_for_url_helper job['cn']
        url_keyword = prepare_for_url_helper @req_prog_language

        container = {
            :company => {
                :name => job['cn'],
                :url => job['src']
            },
            :jobs => [],
            :linkedin_search_urls => {
                :hiring => "http://www.linkedin.com/search/fpsearch?keywords=" << "human" << "&company=" << url_company_name << "&currentCompany=C",
                :keyword => "http://www.linkedin.com/search/fpsearch?keywords=" << url_keyword << "&company=" << url_company_name << "&currentCompany=C"
            }
        }
        company_containers[company_name_clean] = container

        @results.push container

      end

      container[:jobs].push job_map

    end

    render 'searches/search_results'

  end

  # deprecated search method, for reference
  def depr_search


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
      return
    end

    # create the linkedin client that is specific to the user TODO see about keeping this cached within session
    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], cur_user['credentials_linkedin']['token'], cur_user['credentials_linkedin']['secret'], "http://linkedin.com")

    # perform geo-location company search
    nearby_companies = @companies_coll.find({"loc" => {"$near" => [coords['loc']['lat'], coords['loc']['lon']]}}).limit(5)

    company_containers = Hash.new
    company_ids = []

    nearby_companies.each do |nearby_company|

      company_id = nearby_company['id']

      if company_id
        company_id = company_id.to_s
        company_ids.push company_id

        container = {
            :company => {
                :name => nearby_company['name'],
                :url => nearby_company['websiteUrl'],
                :logo_url => nearby_company['logoUrl'],
                :loc => nearby_company['loc']
            },
            :people => []
        }
        company_containers[company_id] = container
        @results.push container
      end
    end

    #todo work out location issue, consider removing search by location

    raw_results = people_search @linkedin_client, company_ids, 'software', 'us:84'

    # raw_results = @linkedin_client.query_people_from_company_ids company_ids, 'software', 'us:84'
    people = raw_results['people']['values']
    cur_company_id = nil
    if people
      people.each do |person|

        #todo get company id from person and then:
        positions = person['positions']
        if positions
          positions = positions['values']
        end

        if !positions
          next
        end
        positions.each do |position|
          if !position['isCurrent']
            next
          end
          cur_company_id = position['company']['id']
        end

        if !cur_company_id
          next
        end
        if company_containers[cur_company_id.to_s]
          company_containers[cur_company_id.to_s][:people].push person
        end

      end
    end

    render 'searches/search_results'

  end

end
