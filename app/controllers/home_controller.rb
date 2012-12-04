require 'whos_using_what/linkedin_client'
require 'yaml'

class HomeController < ApplicationController

  def initialize
    @config = YAML.load_file(File.expand_path("../../../config/linkedin_client.yaml", __FILE__))

    @linkedin_client = LinkedinClient.new(@config["linkedin.api_key"], @config["linkedin.api_secret"], @config["linkedin.user_token"], @config["linkedin.user_secret"], "http://linkedin.com")

  end

  def index

    @books = []
    @books[0] = "tesst"

    puts @linkedin_client.people_search_for_company( "84", "software", "sap")
  end
end
