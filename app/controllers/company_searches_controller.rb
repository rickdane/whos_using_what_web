require_relative '../nosql/mongo_helper'
require_relative '../models/company_search'

class CompanySearchesController < ApplicationController

  before_filter :init

  def init

    @mongo_client = MongoHelper.get_mongo_connection
    @whos_using_what_coll = @mongo_client['whos_using_what']

  end

  def new
    @company_search = CompanySearch.new

  end

  def prepare_linkedin_url_company_name_helper company_name

    if company_name[" "]
      company_name[" "] = "-"
    end

    if company_name[","]
      company_name[","] = ""
    end

    company_name.downcase

  end

  @@number_results_per_page = 10
  #this is just for POC, would need to get this based on user input
  @@keyword = 'ruby'

  def search

    @req_prog_language = @@keyword

    @results = Array.new

    docs = @whos_using_what_coll.find({'location' => params['company_search']['location']}).sort({'employee_range_low' => -1})

    docs.each do |doc|

      url_company_name = prepare_linkedin_url_company_name_helper (doc['name'])

      container = {
          :company => {
              :name => doc['name'],
              :url => "http://www.linkedin.com/company/" << url_company_name
          },
          :jobs => [],
          :linkedin_search_urls => {
              :li_company_page => "http://www.linkedin.com/company/" << url_company_name,
              :search_engine_search => "http://www.google.com/search?q=" << doc['name'] << " " << @@keyword
          }
      }
      @results.push container

    end

    #pagination logic
    current_page = params[:page]
    if !current_page
      current_page = 1
    end

    begin

      @page_results = @results.paginate :page => current_page, :per_page => @@number_results_per_page

    rescue Exception => e
      puts e.message
      puts e.backtrace

    end

    render 'searches/search_results'

  end


end