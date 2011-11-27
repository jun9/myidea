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

ActiveRecord::Schema.define(:version => 20111127040852) do

  create_table "activities", :force => true do |t|
    t.string   "action"
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favors", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favors", ["user_id", "idea_id"], :name => "index_favors_on_user_id_and_idea_id", :unique => true

  create_table "ideas", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "points",         :default => 0
    t.integer  "status",         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.integer  "user_id"
    t.integer  "comments_count", :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "username",                           :null => false
    t.string   "email",                              :null => false
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",           :default => false
    t.boolean  "active",          :default => true
    t.integer  "points",          :default => 0
  end

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "idea_id"
    t.boolean  "like"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id", "idea_id"], :name => "index_votes_on_user_id_and_idea_id", :unique => true

end
