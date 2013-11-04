class Group < ActiveRecord::Base
  attr_accessible :description, :member_id, :name

  has_many(
    	:memberships,
    	:class_name => 'Membership',
    	:primary_key => :id,
    	:foreign_key => :group_id
    )
  has_many(
    	:users,
    	:through => :memberships,
    	:source => :user
    )

end
