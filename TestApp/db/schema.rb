# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140516080357) do

  create_table "twitter3_followers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "follow_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "twitter3_followers", ["follow_id"], :name => "index_twitter3_followers_on_follow_id"
  add_index "twitter3_followers", ["user_id"], :name => "index_twitter3_followers_on_user_id"

  create_table "twitter3_relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.boolean  "accept"
    t.string   "token"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "twitter3_relationships", ["followed_id"], :name => "index_twitter3_relationships_on_followed_id"
  add_index "twitter3_relationships", ["follower_id", "followed_id"], :name => "index_twitter3_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "twitter3_relationships", ["follower_id"], :name => "index_twitter3_relationships_on_follower_id"

  create_table "twitter3_tweets", :force => true do |t|
    t.integer  "user_id"
    t.text     "tweet"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "twitter3_tweets", ["user_id"], :name => "index_twitter3_tweets_on_user_id"

  create_table "twitter3_users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "encrypted_password"
    t.boolean  "confirmed"
    t.string   "token"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

end
