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

ActiveRecord::Schema[8.1].define(version: 2026_08_17_103901) do
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

  create_table "band_recruitments", force: :cascade do |t|
    t.integer "activity_style"
    t.text "comment"
    t.datetime "created_at", null: false
    t.date "deadline", null: false
    t.integer "music_type"
    t.integer "practice_frequency_count"
    t.integer "practice_frequency_unit"
    t.integer "practice_style"
    t.integer "status", default: 0
    t.string "team_name"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.boolean "wants_live_performance", default: false
    t.index ["user_id"], name: "index_band_recruitments_on_user_id"
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
    t.index ["profile_id", "activity_area_id"], name: "idx_on_profile_id_activity_area_id_618dbedb90", unique: true
    t.index ["profile_id"], name: "index_profile_activity_areas_on_profile_id"
  end

  create_table "profile_activity_genres", force: :cascade do |t|
    t.bigint "activity_genre_id", null: false
    t.datetime "created_at", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_genre_id"], name: "index_profile_activity_genres_on_activity_genre_id"
    t.index ["profile_id", "activity_genre_id"], name: "idx_on_profile_id_activity_genre_id_8ae5e106cf", unique: true
    t.index ["profile_id"], name: "index_profile_activity_genres_on_profile_id"
  end

  create_table "profile_favorite_bands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "favorite_band_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["favorite_band_id"], name: "index_profile_favorite_bands_on_favorite_band_id"
    t.index ["profile_id", "favorite_band_id"], name: "idx_on_profile_id_favorite_band_id_902e3d8115", unique: true
    t.index ["profile_id"], name: "index_profile_favorite_bands_on_profile_id"
  end

  create_table "profile_personalities", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "personality_id", null: false
    t.bigint "profile_id", null: false
    t.datetime "updated_at", null: false
    t.index ["personality_id"], name: "index_profile_personalities_on_personality_id"
    t.index ["profile_id", "personality_id"], name: "index_profile_personalities_on_profile_id_and_personality_id", unique: true
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

  create_table "recruitment_activity_areas", force: :cascade do |t|
    t.bigint "activity_area_id", null: false
    t.bigint "band_recruitment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_area_id"], name: "index_recruitment_activity_areas_on_activity_area_id"
    t.index ["band_recruitment_id", "activity_area_id"], name: "idx_on_band_recruitment_id_activity_area_id_4bdb50643d", unique: true
    t.index ["band_recruitment_id"], name: "index_recruitment_activity_areas_on_band_recruitment_id"
  end

  create_table "recruitment_activity_genres", force: :cascade do |t|
    t.bigint "activity_genre_id", null: false
    t.bigint "band_recruitment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_genre_id"], name: "index_recruitment_activity_genres_on_activity_genre_id"
    t.index ["band_recruitment_id", "activity_genre_id"], name: "idx_on_band_recruitment_id_activity_genre_id_c7aabd4499", unique: true
    t.index ["band_recruitment_id"], name: "index_recruitment_activity_genres_on_band_recruitment_id"
  end

  create_table "recruitment_applications", force: :cascade do |t|
    t.text "application_comment"
    t.integer "application_part", null: false
    t.text "approval_comment"
    t.bigint "band_recruitment_id", null: false
    t.datetime "created_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["band_recruitment_id"], name: "index_recruitment_applications_on_band_recruitment_id"
    t.index ["user_id", "band_recruitment_id"], name: "idx_on_user_id_band_recruitment_id_077dab728f", unique: true
    t.index ["user_id"], name: "index_recruitment_applications_on_user_id"
  end

  create_table "recruitment_parts", force: :cascade do |t|
    t.bigint "band_recruitment_id", null: false
    t.datetime "created_at", null: false
    t.integer "max_count", null: false
    t.integer "part", null: false
    t.datetime "updated_at", null: false
    t.index ["band_recruitment_id", "part"], name: "index_recruitment_parts_on_band_recruitment_id_and_part", unique: true
    t.index ["band_recruitment_id"], name: "index_recruitment_parts_on_band_recruitment_id"
  end

  create_table "solid_queue_blocked_executions", force: :cascade do |t|
    t.string "concurrency_key", null: false
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["concurrency_key", "priority", "job_id"], name: "index_solid_queue_blocked_executions_for_release"
    t.index ["expires_at", "concurrency_key"], name: "index_solid_queue_blocked_executions_for_maintenance"
    t.index ["job_id"], name: "index_solid_queue_blocked_executions_on_job_id", unique: true
  end

  create_table "solid_queue_claimed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.bigint "process_id"
    t.index ["job_id"], name: "index_solid_queue_claimed_executions_on_job_id", unique: true
    t.index ["process_id", "job_id"], name: "index_solid_queue_claimed_executions_on_process_id_and_job_id"
  end

  create_table "solid_queue_failed_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "error"
    t.bigint "job_id", null: false
    t.index ["job_id"], name: "index_solid_queue_failed_executions_on_job_id", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "active_job_id"
    t.text "arguments"
    t.string "class_name", null: false
    t.string "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at"
    t.datetime "updated_at", null: false
    t.index ["active_job_id"], name: "index_solid_queue_jobs_on_active_job_id"
    t.index ["class_name"], name: "index_solid_queue_jobs_on_class_name"
    t.index ["finished_at"], name: "index_solid_queue_jobs_on_finished_at"
    t.index ["queue_name", "finished_at"], name: "index_solid_queue_jobs_for_filtering"
    t.index ["scheduled_at", "finished_at"], name: "index_solid_queue_jobs_for_alerting"
  end

  create_table "solid_queue_pauses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "queue_name", null: false
    t.index ["queue_name"], name: "index_solid_queue_pauses_on_queue_name", unique: true
  end

  create_table "solid_queue_processes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "hostname"
    t.string "kind", null: false
    t.datetime "last_heartbeat_at", null: false
    t.text "metadata"
    t.string "name", null: false
    t.integer "pid", null: false
    t.bigint "supervisor_id"
    t.index ["last_heartbeat_at"], name: "index_solid_queue_processes_on_last_heartbeat_at"
    t.index ["name", "supervisor_id"], name: "index_solid_queue_processes_on_name_and_supervisor_id", unique: true
    t.index ["supervisor_id"], name: "index_solid_queue_processes_on_supervisor_id"
  end

  create_table "solid_queue_ready_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.index ["job_id"], name: "index_solid_queue_ready_executions_on_job_id", unique: true
    t.index ["priority", "job_id"], name: "index_solid_queue_poll_all"
    t.index ["queue_name", "priority", "job_id"], name: "index_solid_queue_poll_by_queue"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "run_at", null: false
    t.string "task_key", null: false
    t.index ["job_id"], name: "index_solid_queue_recurring_executions_on_job_id", unique: true
    t.index ["task_key", "run_at"], name: "index_solid_queue_recurring_executions_on_task_key_and_run_at", unique: true
  end

  create_table "solid_queue_recurring_tasks", force: :cascade do |t|
    t.text "arguments"
    t.string "class_name"
    t.string "command", limit: 2048
    t.datetime "created_at", null: false
    t.text "description"
    t.string "key", null: false
    t.integer "priority", default: 0
    t.string "queue_name"
    t.string "schedule", null: false
    t.boolean "static", default: true, null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_solid_queue_recurring_tasks_on_key", unique: true
    t.index ["static"], name: "index_solid_queue_recurring_tasks_on_static"
  end

  create_table "solid_queue_scheduled_executions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.integer "priority", default: 0, null: false
    t.string "queue_name", null: false
    t.datetime "scheduled_at", null: false
    t.index ["job_id"], name: "index_solid_queue_scheduled_executions_on_job_id", unique: true
    t.index ["scheduled_at", "priority", "job_id"], name: "index_solid_queue_dispatch_all"
  end

  create_table "solid_queue_semaphores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.integer "value", default: 1, null: false
    t.index ["expires_at"], name: "index_solid_queue_semaphores_on_expires_at"
    t.index ["key", "value"], name: "index_solid_queue_semaphores_on_key_and_value"
    t.index ["key"], name: "index_solid_queue_semaphores_on_key", unique: true
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
  add_foreign_key "band_recruitments", "users"
  add_foreign_key "profile_activity_areas", "activity_areas"
  add_foreign_key "profile_activity_areas", "profiles"
  add_foreign_key "profile_activity_genres", "activity_genres"
  add_foreign_key "profile_activity_genres", "profiles"
  add_foreign_key "profile_favorite_bands", "favorite_bands"
  add_foreign_key "profile_favorite_bands", "profiles"
  add_foreign_key "profile_personalities", "personalities"
  add_foreign_key "profile_personalities", "profiles"
  add_foreign_key "profiles", "users"
  add_foreign_key "recruitment_activity_areas", "activity_areas"
  add_foreign_key "recruitment_activity_areas", "band_recruitments"
  add_foreign_key "recruitment_activity_genres", "activity_genres"
  add_foreign_key "recruitment_activity_genres", "band_recruitments"
  add_foreign_key "recruitment_applications", "band_recruitments"
  add_foreign_key "recruitment_applications", "users"
  add_foreign_key "recruitment_parts", "band_recruitments"
  add_foreign_key "solid_queue_blocked_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_claimed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_failed_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_ready_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_recurring_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
  add_foreign_key "solid_queue_scheduled_executions", "solid_queue_jobs", column: "job_id", on_delete: :cascade
end
