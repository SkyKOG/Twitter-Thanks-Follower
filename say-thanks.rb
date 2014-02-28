require 'json'
require 'twitter'
require 'redis'

# Need to use OmniAuth to get these dynamically for each user
client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
end

# Create a new redis connection
redis = Redis.new

# Twitter handle of the user of the app
twitter_handle = "SkyKOG"

# Initialise
def setup_old_followers
  # to be stored in redis for the first time
  old_followers = client.followers(twitter_handle).to_a
  old_followers_hash = old_followers.map { |follower| {id: follower.id, name: follower.name, screen_name: follower.screen_name}}
  redis.set twitter_handle, old_followers_hash.to_json
end

# Parse JSON from redis
old_followers = JSON.parse(redis.get(twitter_handle))

# get a list of all ids stored in database since last run
old_ids = []
old_followers.each {|hash| old_ids << hash['id']}

# get latest updated list of followers from twitter
current_followers = client.followers(twitter_handle).to_a

# filter new followers by rejecting the followers already stored in database
latest_followers = current_followers.reject{|current_follower| old_ids.include? current_follower.id}

# send thanks to new followers
if latest_followers # nil check
  latest_followers.each do |follower|
    client.update("Thanks for the follow @#{follower.screen_name}!")
    sleep 5 # prevent blacklist by twitter
  end
end

# hash of new followers
latest_followers_hash = latest_followers.map { |follower| {id: follower.id, name: follower.name, screen_name: follower.screen_name}}
latest_followers_hash = JSON.parse(latest_followers_hash.to_json)

# Add the new followers to existing followers and store back to redis
redis.set twitter_handle, (old_followers|latest_followers_hash).to_json
