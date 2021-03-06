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

ActiveRecord::Schema[7.0].define(version: 2022_04_07_224931) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "number", null: false
    t.float "balance", default: 0.0, null: false
    t.boolean "bank_account", default: false, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_accounts_on_number", unique: true
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "credits", force: :cascade do |t|
    t.float "amount", null: false
    t.bigint "user_id", null: false
    t.bigint "transfer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["transfer_id"], name: "index_credits_on_transfer_id"
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "successful", default: "f", null: false
    t.bigint "sender_account_id", null: false
    t.bigint "recipient_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_account_id"], name: "index_transactions_on_recipient_account_id"
    t.index ["sender_account_id"], name: "index_transactions_on_sender_account_id"
    t.index ["uuid"], name: "index_transactions_on_uuid", unique: true
  end

  create_table "transfers", force: :cascade do |t|
    t.float "amount", null: false
    t.string "category", null: false
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "payment_transaction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_transfers_on_category"
    t.index ["payment_transaction_id"], name: "index_transfers_on_payment_transaction_id"
    t.index ["recipient_id"], name: "index_transfers_on_recipient_id"
    t.index ["sender_id"], name: "index_transfers_on_sender_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "credits", "transfers"
  add_foreign_key "credits", "users"
  add_foreign_key "transactions", "accounts", column: "recipient_account_id"
  add_foreign_key "transactions", "accounts", column: "sender_account_id"
  add_foreign_key "transfers", "transactions", column: "payment_transaction_id"
  add_foreign_key "transfers", "users", column: "recipient_id"
  add_foreign_key "transfers", "users", column: "sender_id"
end
