class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def new

	end

	def show
		@tweets = tweets(params[:id])
		render :json => @tweets
	end
end
