require 'whos_using_what/api_clients/linkedin_client'
require_relative '../nosql/mongo_helper'
require 'whos_using_what/util/map_data_extraction_util'

class WhosUsingWhatController < ApplicationController

  @@base_url = "http://api.linkedin.com/v1/"
  @@num_pages_to_scrape = 25
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
      if !result
        next
      end

      keys_arr1 = ["positions", "values", 0, "company"]
      company = MapDataExtractionUtil.safe_extract_helper keys_arr1, result, nil, nil

      if !company
        next
      end

      existing_company = @whos_using_what_coll.find_one('id' => company['id'])

      if (!existing_company)
        company['keyword_count'] = 1
        company['location'] = @@location

        #calculate the range from the string value
        begin
          range_str = company['size']
          if range_str
            range_arr = range_str.split " ".first
            range_str = range_arr[0]
            range_arr = range_str.split "-"
            if !range_arr[0].include? '+'
              low_range = Integer(range_arr[0])
              high_range = Integer(range_arr[1])
            else
              range_arr[0]["+"] = ""
              range_arr[0][","] = ""
              low_range = Integer(range_arr[0])
              #this is to give an integer value, rather than 10,000+, for example
              high_range = low_range + 1
            end

            company['employee_range_low'] = low_range
            company['employee_range_high'] = high_range
          end
        rescue Exception

        end
        @whos_using_what_coll.insert(company)
      else
        company = existing_company
        count = company['keyword_count'] + 1
        @whos_using_what_coll.update({"_id" => company['_id']}, {"$set" => {'keyword_count' => count}})
      end

    end

  end

end