class ApplicationController < ActionController::Base
	def get_users(user_ids)
		consumer_key = OAuth::Consumer.new(
	        ENV['CONSUMER_KEY'],
	        ENV['CONSUMER_SECRET'])
	    access_token = OAuth::Token.new(
	        ENV['ACCESS_TOKEN'],
	        ENV['ACCESS_TOKEN_SECRET'])

	    users = []

		baseurl = "https://api.twitter.com"
		path    = "/1.1/users/lookup.json"
		query   = URI.encode_www_form("user_id" => user_ids.join(",")) 
		address = URI("#{baseurl}#{path}?#{query}") 

		request = Net::HTTP::Get.new address.request_uri

		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		if response.code == '200' 
			users = JSON.parse(response.body)
		end
		return users
	end
	
	def tweets(twitter_id_str)
		consumer_key = OAuth::Consumer.new(
	        ENV['CONSUMER_KEY'],
	        ENV['CONSUMER_SECRET'])
	    access_token = OAuth::Token.new(
	        ENV['ACCESS_TOKEN'],
	        ENV['ACCESS_TOKEN_SECRET'])

	    tweets = []

		baseurl = "https://api.twitter.com"
		path    = "/1.1/statuses/user_timeline.json"
		query   = URI.encode_www_form("user_id" => twitter_id_str, "count" => 12) 
		address = URI("#{baseurl}#{path}?#{query}") 

		request = Net::HTTP::Get.new address.request_uri

		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		if response.code == '200' 
		tweets = JSON.parse(response.body)
		end
		return tweets
	end

	protect_from_forgery
end
