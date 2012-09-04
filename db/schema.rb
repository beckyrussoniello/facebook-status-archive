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

ActiveRecord::Schema.define(:version => 20120901224621) do

  create_table "archives", :force => true do |t|
    t.integer  "user_id"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "output_format_id"
  end

  create_table "output_formats", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "archive_id"
    t.datetime "timestamp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "message"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "fb_id"
    t.string   "image_url"
    t.string   "oauth_token"
    t.datetime "last_login_at"
    t.string   "oauth_secret"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

end
