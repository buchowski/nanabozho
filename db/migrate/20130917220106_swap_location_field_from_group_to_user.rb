class SwapLocationFieldFromGroupToUser < ActiveRecord::Migration
  def change
  	add_column :users, :location, :string
  	remove_column :groups, :location
  end
end
