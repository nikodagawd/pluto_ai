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

ActiveRecord::Schema[7.1].define(version: 2026_02_04_105124) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
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
    t.string "registration_number"
    t.string "company_status"
    t.date "incorporation_date"
    t.text "sic_codes"
    t.text "popup_bio"
    t.jsonb "key_tags"
    t.jsonb "shareholders"
    t.tsvector "search_vector"
    t.index ["city"], name: "index_companies_on_city"
    t.index ["company_name"], name: "index_companies_on_company_name"
    t.index ["company_name"], name: "index_companies_on_company_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["country"], name: "index_companies_on_country"
    t.index ["founded_year"], name: "index_companies_on_founded_year"
    t.index ["registration_number"], name: "index_companies_on_registration_number", unique: true
    t.index ["search_vector"], name: "index_companies_on_search_vector", using: :gin
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

  create_table "directors", force: :cascade do |t|
    t.bigint "uk_company_id", null: false
    t.string "person_number", limit: 20, null: false
    t.string "officer_id", limit: 50
    t.boolean "is_corporate", default: false, null: false
    t.string "officer_role", limit: 50
    t.string "title", limit: 50
    t.string "forename", limit: 100
    t.string "middle_names", limit: 200
    t.string "surname", limit: 100
    t.string "honours", limit: 100
    t.string "corporate_name", limit: 255
    t.string "full_name", limit: 300
    t.date "appointed_on"
    t.date "resigned_on"
    t.integer "date_of_birth_month", limit: 2
    t.integer "date_of_birth_year", limit: 2
    t.string "nationality", limit: 100
    t.string "country_of_residence", limit: 100
    t.string "occupation", limit: 200
    t.string "address_care_of", limit: 100
    t.string "address_po_box", limit: 20
    t.string "address_premises", limit: 100
    t.string "address_line_1", limit: 100
    t.string "address_line_2", limit: 100
    t.string "address_post_town", limit: 100
    t.string "address_county", limit: 100
    t.string "address_country", limit: 100
    t.string "address_postcode", limit: 20
    t.jsonb "former_names", default: []
    t.string "etag", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["officer_role", "resigned_on"], name: "idx_dir_role_active"
    t.index ["person_number"], name: "idx_dir_person"
    t.index ["surname", "forename"], name: "idx_dir_name"
    t.index ["uk_company_id", "person_number"], name: "idx_dir_company_person_unique", unique: true
    t.index ["uk_company_id", "resigned_on"], name: "idx_dir_company_active"
    t.index ["uk_company_id"], name: "idx_dir_current_only", where: "(resigned_on IS NULL)"
    t.index ["uk_company_id"], name: "index_directors_on_uk_company_id"
  end

  create_table "financial_snapshots", force: :cascade do |t|
    t.bigint "uk_company_id", null: false
    t.date "period_start", null: false
    t.date "period_end", null: false
    t.string "currency", limit: 3, default: "GBP", null: false
    t.bigint "turnover"
    t.bigint "cost_of_sales"
    t.bigint "gross_profit"
    t.bigint "administrative_expenses"
    t.bigint "operating_profit"
    t.bigint "profit_before_tax"
    t.bigint "tax_expense"
    t.bigint "profit_after_tax"
    t.bigint "fixed_assets"
    t.bigint "current_assets"
    t.bigint "total_assets"
    t.bigint "current_liabilities"
    t.bigint "long_term_liabilities"
    t.bigint "total_liabilities"
    t.bigint "net_assets"
    t.bigint "share_capital"
    t.bigint "retained_earnings"
    t.bigint "shareholder_funds"
    t.bigint "cash_and_equivalents"
    t.integer "employee_count"
    t.string "accounts_type", limit: 50
    t.string "accounting_framework", limit: 50
    t.date "filing_date"
    t.string "source_file", limit: 255
    t.boolean "superseded", default: false, null: false
    t.bigint "superseded_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_abridged", default: false
    t.index ["currency", "period_end"], name: "idx_fin_currency_period"
    t.index ["period_end", "turnover"], name: "idx_fin_period_turnover"
    t.index ["turnover"], name: "idx_fin_turnover_active", where: "((turnover IS NOT NULL) AND (superseded = false))"
    t.index ["uk_company_id", "period_end", "superseded"], name: "idx_fin_company_period_unique", unique: true, where: "(superseded = false)"
    t.index ["uk_company_id", "period_end"], name: "idx_fin_company_period", order: { period_end: :desc }
    t.index ["uk_company_id"], name: "index_financial_snapshots_on_uk_company_id"
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

  create_table "people_with_significant_control", force: :cascade do |t|
    t.bigint "uk_company_id", null: false
    t.string "type", limit: 50, null: false
    t.string "kind", limit: 100, null: false
    t.jsonb "natures_of_control", default: [], null: false
    t.string "name", limit: 255
    t.string "etag", limit: 50
    t.date "notified_on"
    t.date "ceased_on"
    t.boolean "ceased", default: false, null: false
    t.string "address_premises", limit: 100
    t.string "address_line_1", limit: 100
    t.string "address_line_2", limit: 100
    t.string "address_locality", limit: 100
    t.string "address_region", limit: 100
    t.string "address_country", limit: 100
    t.string "address_postal_code", limit: 20
    t.string "title", limit: 50
    t.string "forename", limit: 100
    t.string "middle_name", limit: 100
    t.string "surname", limit: 100
    t.string "nationality", limit: 100
    t.string "country_of_residence", limit: 100
    t.integer "date_of_birth_month", limit: 2
    t.integer "date_of_birth_year", limit: 2
    t.string "legal_form", limit: 100
    t.string "legal_authority", limit: 200
    t.string "country_registered", limit: 100
    t.string "place_registered", limit: 200
    t.string "registration_number", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["natures_of_control"], name: "idx_psc_natures_gin", using: :gin
    t.index ["registration_number"], name: "idx_psc_reg_number", where: "(registration_number IS NOT NULL)"
    t.index ["type", "surname"], name: "idx_psc_type_surname"
    t.index ["uk_company_id", "ceased"], name: "idx_psc_company_active"
    t.index ["uk_company_id", "notified_on"], name: "idx_psc_company_notified"
    t.index ["uk_company_id"], name: "idx_psc_active_only", where: "(ceased = false)"
    t.index ["uk_company_id"], name: "index_people_with_significant_control_on_uk_company_id"
  end

  create_table "seed_companies", force: :cascade do |t|
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
  end

  create_table "uk_companies", force: :cascade do |t|
    t.string "company_name", null: false
    t.string "company_number", null: false
    t.string "company_category"
    t.string "company_status"
    t.string "country_of_origin"
    t.date "incorporation_date"
    t.date "dissolution_date"
    t.string "address_care_of"
    t.string "address_po_box"
    t.string "address_line_1"
    t.string "address_line_2"
    t.string "address_post_town"
    t.string "address_county"
    t.string "address_country"
    t.string "address_post_code"
    t.string "sic_code_1"
    t.string "sic_code_2"
    t.string "sic_code_3"
    t.string "sic_code_4"
    t.integer "accounts_ref_day"
    t.integer "accounts_ref_month"
    t.date "accounts_next_due"
    t.date "accounts_last_made_up"
    t.string "accounts_category"
    t.date "conf_stmt_next_due"
    t.date "conf_stmt_last_made_up"
    t.integer "mortgages_charges", default: 0
    t.integer "mortgages_outstanding", default: 0
    t.string "uri"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_target", default: false, null: false
    t.bigint "funding_jump"
    t.decimal "revenue_growth_pct", precision: 10, scale: 2
    t.boolean "is_funded", default: false
    t.boolean "is_growing", default: false
    t.boolean "is_hiring", default: false
    t.bigint "latest_turnover"
    t.integer "latest_employee_count"
    t.datetime "signals_updated_at"
    t.string "website"
    t.string "website_confidence"
    t.jsonb "website_signals"
    t.datetime "website_checked_at"
    t.string "search_label"
    t.text "popup_bio"
    t.string "category"
    t.jsonb "key_tags"
    t.integer "employee_range_min"
    t.integer "employee_range_max"
    t.bigint "turnover_range_min"
    t.bigint "turnover_range_max"
    t.index ["address_post_code"], name: "index_uk_companies_on_address_post_code"
    t.index ["company_name"], name: "index_uk_companies_on_company_name"
    t.index ["company_number"], name: "index_uk_companies_on_company_number", unique: true
    t.index ["company_status"], name: "index_uk_companies_on_company_status"
    t.index ["id"], name: "idx_uk_companies_targets", where: "(is_target = true)"
    t.index ["is_funded"], name: "idx_uk_companies_funded", where: "(is_funded = true)"
    t.index ["is_growing"], name: "idx_uk_companies_growing", where: "(is_growing = true)"
    t.index ["is_hiring"], name: "idx_uk_companies_hiring", where: "(is_hiring = true)"
    t.index ["latest_turnover"], name: "index_uk_companies_on_latest_turnover", where: "(latest_turnover IS NOT NULL)"
    t.index ["sic_code_1"], name: "index_uk_companies_on_sic_code_1"
    t.index ["website"], name: "index_uk_companies_on_website", where: "(website IS NOT NULL)"
    t.index ["website_confidence"], name: "index_uk_companies_on_website_confidence", where: "(website_confidence IS NOT NULL)"
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
  add_foreign_key "directors", "uk_companies"
  add_foreign_key "financial_snapshots", "financial_snapshots", column: "superseded_by_id"
  add_foreign_key "financial_snapshots", "uk_companies"
  add_foreign_key "lists", "users"
  add_foreign_key "messages", "chats"
  add_foreign_key "orders", "users"
  add_foreign_key "people_with_significant_control", "uk_companies"
end
