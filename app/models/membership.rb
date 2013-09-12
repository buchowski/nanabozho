class Membership < ActiveRecord::Base
  attr_accessible :group_id, :user_id

  belongs_to(
    	:user,
    	:class_name => 'User',
    	:primary_key => :id,
    	:foreign_key => :user_id
    )
  belongs_to(
    	:group,
    	:class_name => 'Group',
    	:primary_key => :id,
    	:foreign_key => :group_id
    )
end
