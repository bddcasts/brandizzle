# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090722152636) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "search_results", :force => true do |t|
    t.integer  "search_id"
    t.text     "body"
    t.string   "source"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "follow_up"
  end

  add_index "search_results", ["search_id"], :name => "index_search_results_on_search_id"
  add_index "search_results", ["url"], :name => "index_search_results_on_url", :unique => true

  create_table "searches", :force => true do |t|
    t.integer  "brand_id"
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latest_id"
  end

  add_index "searches", ["brand_id"], :name => "index_searches_on_brand_id"

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
