require_relative '../nosql/mongo_helper'

class CompanySearchesController < ApplicationController

  before_filter :init

  def init

    @mongo_client = MongoHelper.get_mongo_connection
    @whos_using_what_coll = @mongo_client['whos_using_what']

  end

  def new
    @company_search = CompanySearch.new

  end

  @@number_results_per_page = 10

  def search

    @results = Array.new

    docs = @whos_using_what_coll.find()

    docs.each do |doc|

      container = {
          :company => {
              :name => "ll",
              :url => "lll"
          },
          :jobs => [],
          :linkedin_search_urls => {
              :hiring => "http://www.linkedin.com/",
              :keyword => "http://www.linkedin.com/"
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