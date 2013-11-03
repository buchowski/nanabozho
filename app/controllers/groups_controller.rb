include UsersHelper
class GroupsController < ApplicationController
  def index
  	@groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @users = @group.users

    render :show
  end

  def new
    @group = Group.new()
  end

  def create
  	@group = Group.new({name: params[:group][:name], description: params[:group][:description]})
  	if @group.valid? 
  	 	@group.save!	
      params[:group][:users].each do |user|
        user_json = JSON.parse(user)
        p user_json['location']
        @user = User.new({
            name: user_json['name'], 
            description: user_json['description'],
            profile_image_url: user_json['profile_image_url'], 
            twitter_id_str: user_json['id_str'], 
            json_str: user,
            location: user_json['location']
        })
        if @user.valid?
          @user.save! 
          Membership.create!({group_id: @group.id, user_id: @user.id})
        end
      end
      redirect_to group_url(@group)
    else
      render :new
      
    end
  end

  def edit
    @group = Group.find(params[:id])
    @users = @group.users
  end

  def update
    @group = Group.find(params[:id])
    @group.name = params[:group][:name]
    @group.description = params[:group][:description]
    if @group.valid?
      @group.save!
    end

    existing_users = @group.users.pluck(:twitter_id_str)
    future_users = []

    #update & add users. add memberships if necessary
    params[:group][:users].each do |user|
      user_json = JSON.parse(user)
      id_str = user_json['id_str']
      future_users << id_str
      @user = User.find_by_twitter_id_str(id_str)
      if @user #old but not group member
        @user.update_attributes(:name => user_json['name'], :profile_image_url => user_json['profile_image_url'], 
          :twitter_id_str => user_json['id_str'], :description => user_json['description'], :json_str => user,
          :location => user_json['location'])
        if @user.valid?
          @user.save!
        end
        unless existing_users.include?(id_str) #add membership too
          Membership.create!({group_id: @group.id, user_id: @user.id})
        end
      else # new and therefore not group member
        @user = User.new({name: user_json['name'], description: user_json['description'], json_str: user_json[:json_str], 
                  profile_image_url: user_json['profile_image_url'], twitter_id_str: user_json['id_str'], 
                  json_str: user, :location => user_json['location']})
        if @user.valid?
          @user.save!
          Membership.create!({group_id: @group.id, user_id: @user.id})
        end
      end
    end
    
    #delete memberships 
    members_to_delete = existing_users.select { |user| !future_users.include?(user) }
    dogs = members_to_delete.map do |id_str|
      @user = User.find_by_twitter_id_str(id_str)
      p "group #{@group.id}, user #{@user.id}"
      @membership = Membership.find_by_group_id_and_user_id(@group.id, @user.id)
      @membership.destroy
    end
    @users = @group.users

    render :show
  end
  
end
