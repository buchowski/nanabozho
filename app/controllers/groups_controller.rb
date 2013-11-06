class GroupsController < ApplicationController
  def index
    @user_groups = []
  	groups = Group.limit(10);

    groups.each do |group|
      ids = group.users.pluck(:twitter_id_str)
      users = get_users(ids)
      @user_groups << [group, users]
    end
  end

  def show
    @group = Group.find(params[:id])
    ids = @group.users.pluck(:twitter_id_str)
    @users = get_users(ids)
  end

  def new
    @group = Group.new()
    @url = groups_url
  end

  def create
  	@group = Group.new({name: params[:group][:name], description: params[:group][:description]})
  	if @group.valid? 
  	 	@group.save!	
      params[:group][:users].each do |id_str|
        @user = User.new({
            twitter_id_str: id_str 
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
    ids = @group.users.pluck(:twitter_id_str)
    @users = get_users(ids)
    @url = group_url(@group)
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

    params[:group][:users].each do |id_str|
      future_users << id_str
      @user = User.find_by_twitter_id_str(id_str)
      if @user # user is already in the db
        unless existing_users.include?(id_str) #add membership too if user's not part of current group
          Membership.create!({group_id: @group.id, user_id: @user.id})
        end
      else # new and therefore not group member
        @user = User.new({twitter_id_str: id_str})
        if @user.valid?
          @user.save!
          Membership.create!({group_id: @group.id, user_id: @user.id})
        end
      end
    end
    
    #delete memberships 
    members_to_delete = existing_users.select { |user| !future_users.include?(user) }
    members_to_delete.each do |id_str|
      @user = User.find_by_twitter_id_str(id_str)
      @membership = Membership.find_by_group_id_and_user_id(@group.id, @user.id)
      @membership.destroy
    end
    ids = @group.users.pluck(:twitter_id_str)
    @users = get_users(ids)

    render :show
  end
  
end
