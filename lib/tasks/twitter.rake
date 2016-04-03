namespace :twitter do
  desc 'fetch all twitters'
  task fetch_all: :environment do
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = TwitterApi::Application.config.twitter[:consumer_key]
      config.consumer_secret     = TwitterApi::Application.config.twitter[:consumer_secret]
      config.access_token        = TwitterApi::Application.config.twitter[:access_token]
      config.access_token_secret = TwitterApi::Application.config.twitter[:access_token_secret]
      config.proxy = TwitterApi::Application.config.twitter[:config]
    end
    client.update("I'm tweeting with @gem!")
  end

end
