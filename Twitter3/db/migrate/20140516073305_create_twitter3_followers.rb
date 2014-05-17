class CreateTwitter3Followers < ActiveRecord::Migration
  def change
    create_table :twitter3_followers do |t|
      t.references :user
      t.references :follow

      t.timestamps
    end
    add_index :twitter3_followers, :user_id
    add_index :twitter3_followers, :follow_id
  end
end
