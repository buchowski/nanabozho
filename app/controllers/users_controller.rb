class UsersController < ApplicationController

	def index
		@users = User.all
	end

	def new

	end

	def show
		@user = User.find(params[:id])
		@tweets = tweets(@user)

		render :json => @tweets
	end
end
