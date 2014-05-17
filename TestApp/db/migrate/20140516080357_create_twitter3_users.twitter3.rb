# This migration comes from twitter3 (originally 20140516073524)
class CreateTwitter3Users < ActiveRecord::Migration
  def change
    create_table :twitter3_users do |t|
      t.string :username
      t.string :email
      t.string :encrypted_password
      t.boolean :confirmed
      t.string :token
      t.timestamps

    end
  end
end
