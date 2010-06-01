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

ActiveRecord::Schema.define(:version => 20100531074943) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "postal_code"
    t.string   "plan_id"
    t.string   "customer_id"
    t.string   "card_token"
    t.string   "subscription_id"
    t.string   "status"
    t.string   "card_type"
    t.string   "card_number_last_4_digits"
    t.string   "card_expiration_date"
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
    t.string   "state"
    t.integer  "comments_count", :default => 0
    t.integer  "temperature"
    t.boolean  "read",           :default => false
  end

  add_index "brand_results", ["brand_id", "result_id"], :name => "index_brand_results_on_brand_id_and_result_id"
  add_index "brand_results", ["brand_id"], :name => "index_brand_results_on_brand_id"
  add_index "brand_results", ["read"], :name => "index_brand_results_on_read"
  add_index "brand_results", ["result_id"], :name => "index_brand_results_on_result_id"
  add_index "brand_results", ["state"], :name => "index_brand_results_on_state"
  add_index "brand_results", ["temperature"], :name => "index_brand_results_on_temperature"

  create_table "brands", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
  end

  create_table "comments", :force => true do |t|
    t.integer  "brand_result_id"
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["brand_result_id"], :name => "index_comments_on_brand_result_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

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

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "logs", :force => true do |t|
    t.integer  "loggable_id"
    t.string   "loggable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "loggable_attributes"
  end

  add_index "logs", ["loggable_id", "loggable_type"], :name => "index_logs_on_loggable_id_and_loggable_type"

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

  create_table "typus_users", :force => true do |t|
    t.string   "first_name",       :default => "",    :null => false
    t.string   "last_name",        :default => "",    :null => false
    t.string   "role",                                :null => false
    t.string   "email",                               :null => false
    t.boolean  "status",           :default => false
    t.string   "token",                               :null => false
    t.string   "salt",                                :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token",                   :null => false
    t.string   "perishable_token",                    :null => false
    t.boolean  "active",            :default => true, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "team_id"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.string   "twitter_uid"
    t.string   "name"
    t.string   "screen_name"
    t.string   "location"
    t.string   "avatar_url"
    t.integer  "login_count",       :default => 0,    :null => false
    t.datetime "last_request_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["oauth_token"], :name => "index_users_on_oauth_token"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

end
