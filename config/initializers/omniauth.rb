Rails.application.config.middleware.use OmniAuth::Builder do

  unless Rails.env.production?
    @config = YAML.load_file(File.expand_path("../../../config/keys.env", __FILE__))
    ENV["linkedin.api_key"]= @config["linkedin.api_key"]
    ENV["linkedin.api_secret"] = @config["linkedin.api_secret"]
    ENV["linkedin.user_token"] = @config["linkedin.user_token"]
    ENV["linkedin.user_secret"]= @config["linkedin.user_secret"]
  end

  provider :linkedin, ENV["linkedin.api_key"], ENV["linkedin.api_secret"]

end