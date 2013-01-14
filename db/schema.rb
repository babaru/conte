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

ActiveRecord::Schema.define(:version => 20130108031519) do

  create_table "accounts", :force => true do |t|
    t.string   "planet_uid"
    t.string   "access_token"
    t.string   "name"
    t.datetime "expires_at"
    t.boolean  "is_expired"
    t.integer  "planet_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "accounts", ["planet_id"], :name => "index_accounts_on_planet_id"

  create_table "articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "planet_id"
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "scheduled_at"
    t.boolean  "is_published"
    t.datetime "published_at"
    t.string   "type"
    t.string   "sina_weibo_id"
    t.string   "sina_weibo_url"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "attachment_access_token"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "articles", ["account_id"], :name => "index_articles_on_account_id"
  add_index "articles", ["planet_id"], :name => "index_articles_on_planet_id"
  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "planets", :force => true do |t|
    t.string   "name"
    t.string   "app_key"
    t.string   "app_secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "auth_type"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
