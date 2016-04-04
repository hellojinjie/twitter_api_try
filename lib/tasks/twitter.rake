namespace :twitter do
  desc 'twitter api'

  @client = Twitter::REST::Client.new do |config|
    config.consumer_key = TwitterApi::Application.config.twitter[:consumer_key]
    config.consumer_secret = TwitterApi::Application.config.twitter[:consumer_secret]
    config.access_token = TwitterApi::Application.config.twitter[:access_token]
    config.access_token_secret = TwitterApi::Application.config.twitter[:access_token_secret]
  end

  @streamingClient = Twitter::Streaming::Client.new do |config|
    config.consumer_key = TwitterApi::Application.config.twitter[:consumer_key]
    config.consumer_secret = TwitterApi::Application.config.twitter[:consumer_secret]
    config.access_token = TwitterApi::Application.config.twitter[:access_token]
    config.access_token_secret = TwitterApi::Application.config.twitter[:access_token_secret]
  end

  task fetch_all: :environment do
    def collect_with_max_id(collection=[], max_id=nil, &block)
      response = yield(max_id)
      collection += response
      response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
    end

    def @client.get_all_tweets(user)
      collect_with_max_id do |max_id|
        options = {count: 200, include_rts: true}
        options[:max_id] = max_id unless max_id.nil?
        user_timeline(user, options)
      end
    end

    tweets = @client.get_all_tweets('hellojinjie')
    tweets.each do |tweet|
      if tweet.text.include? '心'
        t = Tweet.new({tweet_id: tweet.id, text: tweet.text, created_at: tweet.created_at})
        t.save
      end
    end
  end

  task watch: :environment do
    @streamingClient.user do |object|
      if object.is_a?(Twitter::Tweet)
        if object.text.include? '心'
          t = Tweet.new({tweet_id: object.id, text: object.text, created_at: object.created_at})
          t.save
        end
      end
    end
  end

end
