module UsersHelper
	def tweets(users)
		consumer_key = OAuth::Consumer.new(
	        ENV['CONSUMER_KEY'],
	        ENV['CONSUMER_SECRET'])
	    access_token = OAuth::Token.new(
	        ENV['ACCESS_TOKEN'],
	        ENV['ACCESS_TOKEN_SECRET'])

	    tweets = {}

	    users.each do |user|
	      tweets[user.id] = [] unless tweets[user.id]

	      baseurl = "https://api.twitter.com"
	      path    = "/1.1/statuses/user_timeline.json"
	      query   = URI.encode_www_form("user_id" => user.twitter_id_str, "count" => 12) 
	      address = URI("#{baseurl}#{path}?#{query}") 

	      request = Net::HTTP::Get.new address.request_uri

	      http             = Net::HTTP.new address.host, address.port
	      http.use_ssl     = true
	      http.verify_mode = OpenSSL::SSL::VERIFY_PEER

	      request.oauth! http, consumer_key, access_token
	      http.start
	      response = http.request request
	      
	      if response.code == '200' 
	        temp = JSON.parse(response.body)
	        tweets[user.id] << temp
	      end
	    end
	    return tweets
	end
end
