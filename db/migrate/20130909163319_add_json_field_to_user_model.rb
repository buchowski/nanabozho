class AddJsonFieldToUserModel < ActiveRecord::Migration
  def change
  	add_column :users, :json_str, :string
  end
end
