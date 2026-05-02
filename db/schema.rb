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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_094153) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activity_areas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "activity_genres", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "favorite_bands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "personalities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profile_activity_areas", force: :cascade do |t|
    t.bigint "activity_area_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_area_id"], name: "index_profile_activity_areas_on_activity_area_id"
    t.index ["profile_id"], name: "index_profile_activity_areas_on_profile_id"
  end

  create_table "profile_activity_genres", force: :cascade do |t|
    t.bigint "activity_genre_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_genre_id"], name: "index_profile_activity_genres_on_activity_genre_id"
    t.index ["profile_id"], name: "index_profile_activity_genres_on_profile_id"
  end

  create_table "profile_favorite_bands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "favorite_band_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["favorite_band_id"], name: "index_profile_favorite_bands_on_favorite_band_id"
    t.index ["profile_id"], name: "index_profile_favorite_bands_on_profile_id"
  end

  create_table "profile_personalities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "personality_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["personality_id"], name: "index_profile_personalities_on_personality_id"
    t.index ["profile_id"], name: "index_profile_personalities_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "activity_style"
    t.text "bio"
    t.date "birth_date"
    t.datetime "created_at", null: false
    t.integer "experience_month"
    t.integer "experience_year"
    t.integer "gender"
    t.integer "music_type"
    t.string "nickname", null: false
    t.integer "part"
    t.integer "practice_style"
    t.text "sns_links"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "wants_live_performance", default: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "profile_activity_areas", "activity_areas"
  add_foreign_key "profile_activity_areas", "profiles"
  add_foreign_key "profile_activity_genres", "activity_genres"
  add_foreign_key "profile_activity_genres", "profiles"
  add_foreign_key "profile_favorite_bands", "favorite_bands"
  add_foreign_key "profile_favorite_bands", "profiles"
  add_foreign_key "profile_personalities", "personalities"
  add_foreign_key "profile_personalities", "profiles"
  add_foreign_key "profiles", "users"
end
