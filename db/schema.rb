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

ActiveRecord::Schema.define(:version => 20121203142119) do

  create_table "admins", :force => true do |t|
    t.string   "login",      :default => "admin"
    t.string   "password",   :default => "e10adc3949ba59abbe56e057f20f883e"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt"
  end

  create_table "banners", :force => true do |t|
    t.text     "text"
    t.string   "name"
    t.integer  "pob_id"
    t.integer  "coupon_id"
    t.string   "image"
    t.string   "banner_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bg_color"
    t.string   "text_color"
  end

  add_index "banners", ["coupon_id"], :name => "index_banners_on_coupon_id"
  add_index "banners", ["pob_id"], :name => "index_banners_on_pob_id"

  create_table "clients", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "api_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "last_generation_index", :default => 0
  end

  add_index "clients", ["email"], :name => "index_clients_on_email"
  add_index "clients", ["name"], :name => "index_clients_on_name"

  create_table "coupons", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "image",      :null => false
    t.integer  "pob_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["pob_id"], :name => "index_coupons_on_pob_id"

  create_table "oauth_users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "oauth_token"
    t.integer  "user_id"
    t.string   "email"
    t.string   "nickname"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_users", ["email"], :name => "index_oauth_users_on_email"
  add_index "oauth_users", ["oauth_token"], :name => "index_oauth_users_on_oauth_token"
  add_index "oauth_users", ["provider", "uid"], :name => "index_oauth_users_on_provider_and_uid"

  create_table "orders", :force => true do |t|
    t.integer  "tour_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.text     "receipt"
  end

  add_index "orders", ["user_id", "tour_id"], :name => "index_orders_on_user_id_and_tour_id", :unique => true

  create_table "pob_categories", :id => false, :force => true do |t|
    t.string   "name",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_draft",   :default => false
    t.integer  "id",                            :null => false
    t.integer  "parent_id"
  end

  create_table "pob_categories_pobs", :id => false, :force => true do |t|
    t.integer "pob_id"
    t.integer "pob_category_id"
  end

  add_index "pob_categories_pobs", ["pob_id", "pob_category_id"], :name => "index_pob_categories_pobs_on_pob_id_and_pob_category_id"

  create_table "pob_images", :force => true do |t|
    t.integer "pob_id"
    t.string  "image"
  end

  add_index "pob_images", ["pob_id"], :name => "index_pob_images_on_pob_id"

  create_table "pobs", :force => true do |t|
    t.string   "name",                                       :null => false
    t.string   "country",                                    :null => false
    t.text     "description"
    t.decimal  "latitude",    :precision => 12, :scale => 6, :null => false
    t.decimal  "longitude",   :precision => 12, :scale => 6, :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "city"
    t.string   "address"
    t.string   "icon"
    t.string   "open_hours"
    t.string   "price_range"
    t.string   "phone"
    t.string   "email"
    t.string   "txt_file"
  end

  add_index "pobs", ["city"], :name => "index_pobs_on_city"
  add_index "pobs", ["country", "name"], :name => "index_pobs_on_country_and_name"
  add_index "pobs", ["latitude"], :name => "index_pobs_on_latitude"
  add_index "pobs", ["longitude"], :name => "index_pobs_on_longitude"

  create_table "pobs_bundles", :force => true do |t|
    t.integer  "tour_id"
    t.float    "south"
    t.float    "north"
    t.float    "west"
    t.float    "east"
    t.string   "link_to_bundle"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "categories_ids"
  end

  add_index "pobs_bundles", ["south", "north", "west", "east"], :name => "index_pobs_bundles_on_south_and_north_and_west_and_east"

  create_table "products", :force => true do |t|
    t.string   "country"
    t.string   "city"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tour_ubertours", :force => true do |t|
    t.integer "tour_id"
    t.integer "ubertour_id"
  end

  add_index "tour_ubertours", ["tour_id", "ubertour_id"], :name => "index_tour_ubertours_on_tour_id_and_ubertour_id"

  create_table "tours", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "url"
    t.integer  "build_id"
    t.string   "country"
    t.string   "city"
    t.boolean  "free",           :default => false
    t.integer  "orders_count",   :default => 0
    t.integer  "client_id"
    t.string   "status",         :default => "generic"
    t.boolean  "is_ubertour",    :default => false
    t.integer  "subtours_count", :default => 0
    t.string   "aasm_state"
    t.boolean  "is_published",   :default => false,     :null => false
  end

  add_index "tours", ["aasm_state"], :name => "index_tours_on_aasm_state"
  add_index "tours", ["client_id", "is_ubertour"], :name => "index_tours_on_client_id_and_is_ubertour"
  add_index "tours", ["client_id"], :name => "index_tours_on_client_id"
  add_index "tours", ["orders_count"], :name => "index_tours_on_orders_count"
  add_index "tours", ["status"], :name => "index_tours_on_status"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",    :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",    :null => false
    t.string   "authentication_token"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "name"
    t.integer  "orders_count",                          :default => 0
    t.integer  "client_id"
    t.integer  "generation_index",                      :default => 0
    t.boolean  "is_preview_user",                       :default => false
  end

  add_index "users", ["client_id", "generation_index"], :name => "index_users_on_client_id_and_generation_index"
  add_index "users", ["client_id"], :name => "index_users_on_client_id"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["orders_count"], :name => "index_users_on_orders_count"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
