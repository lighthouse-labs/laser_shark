# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150210021356) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.integer  "start_time"
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "day"
    t.string   "gist_url"
    t.text     "instructions"
    t.text     "teacher_notes"
    t.string   "file_name"
    t.boolean  "allow_submissions", default: true
    t.string   "media_filename"
  end

  create_table "activity_submissions", force: true do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "completed_at"
    t.string   "github_url"
  end

  add_index "activity_submissions", ["activity_id"], name: "index_activity_submissions_on_activity_id", using: :btree
  add_index "activity_submissions", ["user_id"], name: "index_activity_submissions_on_user_id", using: :btree

  create_table "admins", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assistance_requests", force: true do |t|
    t.integer  "requestor_id"
    t.integer  "assistor_id"
    t.datetime "start_at"
    t.datetime "assistance_start_at"
    t.datetime "assistance_end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assistance_id"
    t.datetime "canceled_at"
  end

  create_table "assistances", force: true do |t|
    t.integer  "assistor_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assistee_id"
  end

  create_table "cohorts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.string   "code"
  end

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "day_feedbacks", force: true do |t|
    t.string   "mood"
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "day"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone_number"
    t.string   "twitter"
    t.string   "skype"
    t.string   "uid"
    t.string   "token"
    t.boolean  "completed_registration"
    t.string   "github_username"
    t.string   "avatar_url"
    t.integer  "cohort_id"
    t.string   "type"
    t.string   "custom_avatar"
    t.string   "unlocked_until_day"
    t.datetime "last_assisted_at"
    t.datetime "deactivated_at"
  end

  add_index "users", ["cohort_id"], name: "index_users_on_cohort_id", using: :btree

end
