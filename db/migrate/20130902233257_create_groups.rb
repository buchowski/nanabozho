class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :description
      t.string :member_id

      t.timestamps
    end
    add_index :groups, :member_id
  end
end
