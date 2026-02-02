# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2026_02_02_085618) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "companies", force: :cascade do |t|
    t.text "system_prompt"
    t.string "company_name", null: false
    t.string "address"
    t.string "city"
    t.string "country"
    t.text "description"
    t.decimal "revenue", precision: 15, scale: 2
    t.string "owner"
    t.integer "employees"
    t.string "sector"
    t.string "sub_sector"
    t.string "website"
    t.integer "founded_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city"], name: "index_companies_on_city"
    t.index ["company_name"], name: "index_companies_on_company_name"
    t.index ["country"], name: "index_companies_on_country"
    t.index ["founded_year"], name: "index_companies_on_founded_year"
    t.index ["sector"], name: "index_companies_on_sector"
    t.index ["sub_sector"], name: "index_companies_on_sub_sector"
  end

  create_table "company_lists", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "list_id"], name: "index_company_lists_on_company_id_and_list_id", unique: true
    t.index ["company_id"], name: "index_company_lists_on_company_id"
    t.index ["list_id"], name: "index_company_lists_on_list_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_lists_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.string "role", null: false
    t.text "content", null: false
    t.bigint "chat_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "state"
    t.bigint "user_id", null: false
    t.string "plan"
    t.string "stripe_payment_link_id"
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "username", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "company_lists", "companies"
  add_foreign_key "company_lists", "lists"
  add_foreign_key "lists", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "orders", "users"
end
