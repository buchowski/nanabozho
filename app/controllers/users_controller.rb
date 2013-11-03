class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def new

	end

	def show
		#get user
		# @twitter_id_str = params[:twitter_id_str]
		# @user = User.where("twitter_id_str = ?", params[:twitter_id_str])
		@user = User.find(params[:id])

		#get tweets
		@tweets = tweets(@user)
		p @tweets
		#return tweets
		render :json => @tweets
	end
end
