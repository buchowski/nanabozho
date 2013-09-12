class ChangeUserJsonFromStringToText < ActiveRecord::Migration
  def change
  	remove_column :users, :json_str
  	add_column :users, :json_str, :text
  end
end
