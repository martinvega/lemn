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

ActiveRecord::Schema.define(:version => 20120812000822) do

  create_table "assistances", :force => true do |t|
    t.date     "date",                        :null => false
    t.integer  "partner_id",                  :null => false
    t.integer  "user_id",                     :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "assistances", ["partner_id"], :name => "index_assistances_on_partner_id"
  add_index "assistances", ["user_id"], :name => "index_assistances_on_user_id"

  create_table "partners", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "lastname",                      :null => false
    t.string   "address"
    t.integer  "phone"
    t.integer  "movil_phone"
    t.string   "email"
    t.date     "admission_date"
    t.date     "birth_date"
    t.integer  "document"
    t.integer  "user_id"
    t.integer  "lock_version",   :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "partners", ["user_id"], :name => "index_partners_on_user_id"

  create_table "payments", :force => true do |t|
    t.date     "date",                        :null => false
    t.float    "amount",                      :null => false
    t.string   "concept",                     :null => false
    t.integer  "partner_id",                  :null => false
    t.integer  "user_id",                     :null => false
    t.integer  "lock_version", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "payments", ["partner_id"], :name => "index_payments_on_partner_id"
  add_index "payments", ["user_id"], :name => "index_payments_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name",                                   :null => false
    t.string   "lastname"
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
    t.integer  "roles_mask",             :default => 0,  :null => false
    t.integer  "lock_version",           :default => 0,  :null => false
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["lastname"], :name => "index_users_on_lastname"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.integer  "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"
  add_index "versions", ["whodunnit"], :name => "index_versions_on_whodunnit"

end
