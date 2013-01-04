require 'whos_using_what/api_clients/linkedin_client'
require_relative '../nosql/mongo_helper'

class WhosUsingWhatController < ApplicationController

  def show
    base_url = "http://api.linkedin.com/v1/"
    cur_user = current_user

    location = 'us:82'

    @mongo_client = MongoHelper.get_mongo_connection
    @whos_using_what_coll = @mongo_client['whos_using_what']

    keyword = "ruby"

    @linkedin_client = LinkedinClient.new(ENV["linkedin.api_key"], ENV["linkedin.api_secret"], cur_user['credentials_linkedin']['token'], cur_user['credentials_linkedin']['secret'], "http://linkedin.com")

    url = base_url <<
        "people-search:(people:(id,first-name,last-name,public-profile-url,picture-url,headline,positions:(is-current,company:(id,name,url,industries,employee-count-range))))" <<
        "?facets=location" <<
        "&facet=location," << location <<
        "&keyword=" << keyword << "&start=10"

    results = @linkedin_client.json_api_call_helper url, {}, true

    results = results['people']['values']

    results.each do |result|
      company = result['positions']['values'][0]['company']
      l = ""
    end

    s = ""

  end

end