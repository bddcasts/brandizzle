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

ActiveRecord::Schema.define(:version => 20100401090031) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_id"
  end

  create_table "brand_queries", :force => true do |t|
    t.integer "brand_id"
    t.integer "query_id"
  end

  add_index "brand_queries", ["brand_id", "query_id"], :name => "index_brand_queries_on_brand_id_and_query_id"
  add_index "brand_queries", ["brand_id"], :name => "index_brand_queries_on_brand_id"
  add_index "brand_queries", ["query_id"], :name => "index_brand_queries_on_query_id"

  create_table "brand_results", :force => true do |t|
    t.integer  "brand_id"
    t.integer  "result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "follow_up",  :default => false
  end

  add_index "brand_results", ["brand_id", "result_id"], :name => "index_brand_results_on_brand_id_and_result_id"
  add_index "brand_results", ["brand_id"], :name => "index_brand_results_on_brand_id"
  add_index "brand_results", ["result_id"], :name => "index_brand_results_on_result_id"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "queries", :force => true do |t|
    t.string   "term"
    t.string   "latest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "results", :force => true do |t|
    t.text     "body"
    t.string   "source"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "results", ["url"], :name => "index_results_on_url", :unique => true

  create_table "search_results", :force => true do |t|
    t.integer "query_id"
    t.integer "result_id"
  end

  add_index "search_results", ["query_id", "result_id"], :name => "index_search_results_on_query_id_and_result_id"
  add_index "search_results", ["query_id"], :name => "index_search_results_on_query_id"
  add_index "search_results", ["result_id"], :name => "index_search_results_on_result_id"

  create_table "teams", :force => true do |t|
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",                   :null => false
    t.string   "perishable_token",                    :null => false
    t.boolean  "active",            :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_limit"
    t.integer  "team_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
