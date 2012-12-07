require 'rubygems'
require 'mongo'
require 'uri'
require 'json'

include Mongo

class MongodbTest

  def initialize
    @config = YAML.load_file(File.expand_path("../../../config/mongo.env", __FILE__))
    ENV["mongo.host"]= @config["mongo.host"]
    ENV["mongo.port"]= @config["mongo.port"]
    ENV["mongo.user"]= @config["mongo.user"]
    ENV["mongo.pass"]= @config["mongo.pass"]
    ENV["mongo.dbname"] = @config["mongo.dbname"]
    ENV["mongo.uri"] = "mongodb://" << ENV["mongo.user"] << ":" << ENV["mongo.pass"] << "@" <<
        ENV["mongo.host"] <<":" << ENV["mongo.port"] <<"/" << ENV["mongo.dbname"]

  end

  def get_connection
    return @db_connection if @db_connection
    db = URI.parse(ENV["mongo.uri"].strip)
    db_name = db.path.gsub(/^\//, '')
    @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
    @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
    @db_connection
  end


  def conn_test # gem install mongo bson_ext json

    db = get_connection

    puts "Collections"
    puts "==========="
    collections = db.collection_names
    puts collections

    last_collection = collections[-1]
    coll = db.collection(last_collection)

# just show 5
    docs = coll.find().limit(5)

    puts "\nDocuments in #{last_collection}"
    puts " #{docs.count()} documents(s) found"
    puts "=========================="
    docs.each { |doc| puts doc.to_json }
  end

  if __FILE__ == $PROGRAM_NAME
    mongotest = MongodbTest.new
    mongotest.conn_test


  end


end
