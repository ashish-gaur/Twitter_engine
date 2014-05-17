class CreateTwitter3Tweets < ActiveRecord::Migration
  def change
    create_table :twitter3_tweets do |t|
      t.references :user
      t.text :tweet

      t.timestamps
    end
    add_index :twitter3_tweets, :user_id
  end
end
