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

ActiveRecord::Schema.define(:version => 20110503193936) do

  create_table "assessments", :force => true do |t|
    t.integer  "kase_id"
    t.integer  "user_id"
    t.integer  "survey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "contacts", :force => true do |t|
    t.integer  "kase_id"
    t.integer  "user_id"
    t.datetime "date_time"
    t.string   "method"
    t.string   "description"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "customer_impairments", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "impairment_id"
    t.datetime "created_at"
    t.integer  "created_by_id"
  end

  create_table "customer_support_network_members", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "title"
    t.string   "organization"
    t.string   "phone_number"
    t.string   "email"
    t.datetime "created_at"
    t.integer  "created_by_id"
    t.datetime "updated_at"
    t.integer  "updated_by_id"
    t.integer  "lock_version",  :default => 0
  end

  create_table "customers", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.date     "birth_date"
    t.string   "gender"
    t.string   "phone_number_1"
    t.string   "phone_number_2"
    t.string   "email"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "ethnicity_id"
    t.text     "notes"
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",          :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "dispositions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "ethnicities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "events", :force => true do |t|
    t.integer  "kase_id"
    t.integer  "user_id"
    t.datetime "date_time"
    t.integer  "event_type_id"
    t.integer  "funding_source_id"
    t.decimal  "duration_in_hours", :precision => 5, :scale => 2
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                                    :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "funding_sources", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "impairments", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "kase_routes", :force => true do |t|
    t.integer  "kase_id"
    t.integer  "route_id"
    t.datetime "created_at"
    t.integer  "created_by_id"
  end

  create_table "kases", :force => true do |t|
    t.integer  "customer_id"
    t.date     "open_date"
    t.date     "close_date"
    t.string   "referral_source"
    t.integer  "referral_type_id"
    t.integer  "user_id"
    t.integer  "funding_source_id"
    t.integer  "disposition_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",      :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "outcomes", :force => true do |t|
    t.integer  "kase_id"
    t.integer  "trip_reason_id"
    t.integer  "exit_trip_count"
    t.integer  "exit_vehicle_miles_reduced"
    t.integer  "three_month_trip_count"
    t.integer  "three_month_vehicle_miles_reduced"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                      :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
    t.integer  "six_month_trip_count"
    t.integer  "six_month_vehicle_miles_reduced"
    t.boolean  "six_month_unreachable"
    t.boolean  "three_month_unreachable"
  end

  create_table "referral_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "routes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "trip_reasons", :force => true do |t|
    t.string   "name"
    t.boolean  "work_related"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",  :default => 0
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "created_by_id"
    t.integer  "updated_by_id"
  end

end
