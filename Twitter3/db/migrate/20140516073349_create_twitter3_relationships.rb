class CreateTwitter3Relationships < ActiveRecord::Migration
  def change
    create_table :twitter3_relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.boolean :accept
      t.string :token
      t.timestamps
    end
    add_index :twitter3_relationships, :follower_id
    add_index :twitter3_relationships, :followed_id
    add_index :twitter3_relationships, [:follower_id, :followed_id], unique: true
  end
end
