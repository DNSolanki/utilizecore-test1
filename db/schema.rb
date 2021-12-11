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

ActiveRecord::Schema.define(version: 2021_12_11_190705) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "address_line_one", null: false
    t.string "address_line_two"
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.string "pincode", null: false
    t.string "mobile_number", null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "parcel_histories", force: :cascade do |t|
    t.bigint "parcel_id", null: false
    t.string "status", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parcel_id"], name: "index_parcel_histories_on_parcel_id"
  end

  create_table "parcels", force: :cascade do |t|
    t.decimal "weight", precision: 8, scale: 2
    t.string "status"
    t.bigint "service_type_id"
    t.string "payment_mode"
    t.bigint "sender_id"
    t.bigint "receiver_id"
    t.decimal "cost", precision: 8, scale: 2
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "parcel_number"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.index ["parcel_number"], name: "index_parcels_on_parcel_number", unique: true
    t.index ["receiver_id"], name: "index_parcels_on_receiver_id"
    t.index ["sender_id"], name: "index_parcels_on_sender_id"
    t.index ["service_type_id"], name: "index_parcels_on_service_type_id"
  end

  create_table "service_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "role", default: "User"
    t.bigint "created_by"
    t.bigint "updated_by"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
