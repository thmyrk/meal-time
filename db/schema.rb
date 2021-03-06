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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180711122822) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "meals", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "price",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "order_id",   null: false
    t.integer  "user_id",    null: false
    t.index ["order_id"], name: "index_meals_on_order_id", using: :btree
    t.index ["user_id"], name: "index_meals_on_user_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.string   "name",                         null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "status",       default: "New", null: false
    t.integer  "payer_id"
    t.string   "bank_account"
    t.index ["payer_id"], name: "index_orders_on_payer_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.text     "name"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.bigint   "facebook_id"
    t.string   "access_token"
    t.integer  "token_expire"
    t.bigint   "github_id"
  end

  add_foreign_key "meals", "orders"
  add_foreign_key "meals", "users"
  add_foreign_key "orders", "users", column: "payer_id"
end
