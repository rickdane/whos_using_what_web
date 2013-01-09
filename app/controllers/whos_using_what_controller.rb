require 'whos_using_what/api_clients/linkedin_client'
require_relative '../nosql/mongo_helper'

class WhosUsingWhatController < ApplicationController

  @@base_url = "http://api.linkedin.com/v1/"
  @@num_pages_to_scrape = 4
  @@location = 'us:82'

  def show

    cur_user = current_user

    @mongo_client = MongoHelper.get_mongo_connection
    @whos_using_what_coll = @mongo_client['whos_using_what']

    keyword = "ruby"

    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], cur_user['credentials_linkedin']['token'], cur_user['credentials_linkedin']['secret'], "http://linkedin.com")

    i = 0
    while (i < @@num_pages_to_scrape)
      gather_results i * 10, keyword
      i = i +1
    end


  end

  def gather_results start, keyword

    url = @@base_url <<
        "people-search:(people:(id,first-name,last-name,public-profile-url,picture-url,headline,positions:(is-current,company:(id,name,size))))" <<
        "?facets=location" <<
        "&facet=location," << @@location <<
        "&keywords=" << keyword << "&start=" << start.to_s

    results = @linkedin_client.json_api_call_helper url, {}, true

    results = results['people']['values']

    results.each do |result|
      company = result['positions']['values'][0]['company']

      existing_company = @whos_using_what_coll.find_one('id' => company['id'])

      if (!existing_company)
        company['keyword_count'] = 1
        @whos_using_what_coll.insert(company)
      else
        company = existing_company
        count = company['keyword_count'] + 1
        @whos_using_what_coll.update({"_id" => company['_id']}, {"$set" => {'keyword_count' => count}})
      end

    end

  end

end