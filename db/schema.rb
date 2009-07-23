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

ActiveRecord::Schema.define(:version => 20090723134645) do

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "brands_searches", :id => false, :force => true do |t|
    t.integer "brand_id"
    t.integer "search_id"
  end

  add_index "brands_searches", ["brand_id", "search_id"], :name => "index_brands_searches_on_brand_id_and_search_id"
  add_index "brands_searches", ["brand_id"], :name => "index_brands_searches_on_brand_id"
  add_index "brands_searches", ["search_id"], :name => "index_brands_searches_on_search_id"

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
    t.string   "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "latest_id"
  end

end
