class User < ActiveRecord::Base
  attr_accessible :description, :name, :profile_image_url, :twitter_id_str, :json_str, :location

  has_many(
    	:memberships,
    	:class_name => 'Membership',
    	:primary_key => :id,
    	:foreign_key => :user_id
    )
  has_many( 
    	:groups,
    	:through => :membership,
    	:source => :group
    )
end
