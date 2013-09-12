class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :profile_image_url
      t.string :twitter_id_str
      t.string :description

      t.timestamps
    end
  end
end
