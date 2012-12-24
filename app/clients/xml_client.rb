require 'whos_using_what/base_api_client'

class XmlClient

  def initialize

    @@api_client = BaseApiClient.new

  end

  params = {

  }

  prepare_params_from_map_helper params

  #useful for calling any api that returns XML in indeed format (which seems to be standard format for these types of API's)
  def call_indeed_format_api base_url params_map

    @@api_client.prepare_params_from_map_helper (base_url, params_map)

  end


end

