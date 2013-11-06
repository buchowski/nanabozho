class SearchesController < ApplicationController

	def new

	end

	def create
		@user = params[:user]

		 	consumer_key = OAuth::Consumer.new(
		       ENV['CONSUMER_KEY'],
		       ENV['CONSUMER_SECRET'])
		   access_token = OAuth::Token.new(
		       ENV['ACCESS_TOKEN'],
		       ENV['ACCESS_TOKEN_SECRET'])

		baseurl = "https://api.twitter.com"
		path    = "/1.1/users/search.json"
		query   = URI.encode_www_form("q" => @user['name'], "page" => @user['page'])
		address = URI("#{baseurl}#{path}?#{query}")

		request = Net::HTTP::Get.new address.request_uri

		http             = Net::HTTP.new address.host, address.port
		http.use_ssl     = true
		http.verify_mode = OpenSSL::SSL::VERIFY_PEER

		request.oauth! http, consumer_key, access_token
		http.start
		response = http.request request

		@users = nil
		if response.code == '200' 
		  @users = JSON.parse(response.body)
		end

		render :json => @users
	end

	def show
		

	end
end
