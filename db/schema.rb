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

ActiveRecord::Schema.define(version: 2019_06_08_094216) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "api_keys", id: :serial, force: :cascade do |t|
    t.jsonb "app_info", default: {}, null: false
    t.string "token", null: false
  end

  create_table "applicants", force: :cascade do |t|
    t.integer "status", limit: 2
    t.bigint "user_id"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_applicants_on_job_id"
    t.index ["user_id"], name: "index_applicants_on_user_id"
  end

  create_table "basic_informations", force: :cascade do |t|
    t.string "name"
    t.datetime "birth_date"
    t.jsonb "phone_numbers", default: {}
    t.jsonb "social_accounts", default: {}
    t.integer "role", limit: 2
    t.text "description"
    t.string "website"
    t.bigint "user_id"
    t.jsonb "address", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_basic_informations_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_basic_informations", id: false, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "basic_information_id"
    t.index ["basic_information_id"], name: "index_categories_basic_informations_on_basic_information_id"
    t.index ["category_id"], name: "index_categories_basic_informations_on_category_id"
  end

  create_table "categories_educations", id: false, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "education_id"
    t.index ["category_id"], name: "index_categories_educations_on_category_id"
    t.index ["education_id"], name: "index_categories_educations_on_education_id"
  end

  create_table "categories_jobs", id: false, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "job_id"
    t.index ["category_id"], name: "index_categories_jobs_on_category_id"
    t.index ["job_id"], name: "index_categories_jobs_on_job_id"
  end

  create_table "categories_work_experiences", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "work_experience_id"
    t.index ["category_id"], name: "index_categories_work_experiences_on_category_id"
    t.index ["work_experience_id"], name: "index_categories_work_experiences_on_work_experience_id"
  end

  create_table "educations", force: :cascade do |t|
    t.string "degree"
    t.string "program"
    t.datetime "start_date"
    t.datetime "end_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_educations_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "uid"
    t.text "description"
    t.string "title"
    t.float "min_salary"
    t.float "max_salary"
    t.jsonb "features", default: {}
    t.integer "open_seats", default: 1
    t.integer "level", limit: 2
    t.integer "type", limit: 2
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", limit: 2, default: 0
    t.string "uid", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "work_experiences", force: :cascade do |t|
    t.string "organization_name"
    t.string "job_title"
    t.string "title"
    t.string "level"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_work_experiences_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "applicants", "jobs"
  add_foreign_key "applicants", "users"
  add_foreign_key "basic_informations", "users"
  add_foreign_key "categories_basic_informations", "basic_informations"
  add_foreign_key "categories_basic_informations", "categories"
  add_foreign_key "categories_educations", "categories"
  add_foreign_key "categories_educations", "educations"
  add_foreign_key "categories_jobs", "categories"
  add_foreign_key "categories_jobs", "jobs"
  add_foreign_key "categories_work_experiences", "categories"
  add_foreign_key "categories_work_experiences", "work_experiences"
  add_foreign_key "educations", "users"
  add_foreign_key "jobs", "users"
end
