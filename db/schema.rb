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

ActiveRecord::Schema.define(version: 20160330171721) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
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
    t.boolean  "allow_submissions",   default: true
    t.string   "media_filename"
    t.string   "revisions_gistid"
    t.integer  "code_review_percent", default: 60
    t.boolean  "allow_feedback",      default: true
    t.integer  "quiz_id"
  end

  add_index "activities", ["quiz_id"], name: "index_activities_on_quiz_id", using: :btree
  add_index "activities", ["start_time"], name: "index_activities_on_start_time", using: :btree

  create_table "activity_messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cohort_id"
    t.integer  "activity_id"
    t.string   "kind",          limit: 50
    t.string   "day",           limit: 5
    t.string   "subject",       limit: 1000
    t.text     "body"
    t.text     "teacher_notes"
    t.boolean  "for_students"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_messages", ["activity_id"], name: "index_activity_messages_on_activity_id", using: :btree
  add_index "activity_messages", ["cohort_id"], name: "index_activity_messages_on_cohort_id", using: :btree
  add_index "activity_messages", ["day"], name: "index_activity_messages_on_day", using: :btree
  add_index "activity_messages", ["user_id"], name: "index_activity_messages_on_user_id", using: :btree

  create_table "activity_submissions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "completed_at"
    t.string   "github_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_submissions", ["activity_id"], name: "index_activity_submissions_on_activity_id", using: :btree
  add_index "activity_submissions", ["user_id"], name: "index_activity_submissions_on_user_id", using: :btree

  create_table "answers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "assistance_requests", force: :cascade do |t|
    t.integer  "requestor_id"
    t.integer  "assistor_id"
    t.datetime "start_at"
    t.datetime "assistance_start_at"
    t.datetime "assistance_end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assistance_id"
    t.datetime "canceled_at"
    t.string   "type"
    t.integer  "activity_submission_id"
    t.text     "reason"
  end

  add_index "assistance_requests", ["activity_submission_id"], name: "index_assistance_requests_on_activity_submission_id", using: :btree

  create_table "assistances", force: :cascade do |t|
    t.integer  "assistor_id"
    t.datetime "start_at"
    t.datetime "end_at"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "assistee_id"
    t.integer  "rating"
  end

  create_table "cohorts", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.string   "code"
    t.string   "teacher_email_group"
    t.integer  "program_id"
    t.integer  "location_id"
  end

  add_index "cohorts", ["program_id"], name: "index_cohorts_on_program_id", using: :btree

  create_table "day_feedbacks", force: :cascade do |t|
    t.string   "mood"
    t.string   "title"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "day"
    t.datetime "archived_at"
    t.integer  "archived_by_user_id"
    t.text     "notes"
  end

  create_table "day_infos", force: :cascade do |t|
    t.string   "day"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "teacher_id"
    t.integer  "technical_rating"
    t.integer  "style_rating"
    t.text     "notes"
    t.integer  "feedbackable_id"
    t.string   "feedbackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "rating"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "calendar"
    t.string   "timezone"
    t.boolean  "has_code_reviews", default: true
  end

  create_table "options", force: :cascade do |t|
    t.text     "answer"
    t.text     "explanation"
    t.boolean  "correct"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "programs", force: :cascade do |t|
    t.string   "name"
    t.text     "lecture_tips"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "recordings_folder"
    t.string   "recordings_bucket"
    t.string   "tag"
  end

  create_table "questions", force: :cascade do |t|
    t.text     "question"
    t.boolean  "active"
    t.integer  "created_by_user_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "questions_quizzes", id: false, force: :cascade do |t|
    t.integer "question_id"
    t.integer "quiz_id"
  end

  add_index "questions_quizzes", ["question_id"], name: "index_questions_quizzes_on_question_id", using: :btree
  add_index "questions_quizzes", ["quiz_id"], name: "index_questions_quizzes_on_quiz_id", using: :btree

  create_table "quiz_submissions", force: :cascade do |t|
    t.string   "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "quiz_id"
    t.integer  "user_id"
  end

  add_index "quiz_submissions", ["quiz_id"], name: "index_quiz_submissions_on_quiz_id", using: :btree
  add_index "quiz_submissions", ["user_id"], name: "index_quiz_submissions_on_user_id", using: :btree

  create_table "quizzes", force: :cascade do |t|
    t.string   "day"
    t.string   "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recordings", force: :cascade do |t|
    t.string   "file_name"
    t.datetime "recorded_at"
    t.integer  "presenter_id"
    t.integer  "cohort_id"
    t.integer  "activity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "program_id"
    t.string   "title"
    t.string   "presenter_name"
  end

  create_table "streams", force: :cascade do |t|
    t.string   "title"
    t.string   "description"
    t.string   "wowza_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
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
    t.string   "slack"
    t.boolean  "remote",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "code_review_percent",    default: 80
    t.boolean  "admin",                  default: false, null: false
    t.string   "company_name"
    t.string   "company_url"
    t.text     "bio"
    t.string   "quirky_fact"
    t.string   "specialties"
    t.integer  "location_id"
    t.boolean  "on_duty",                default: false
    t.integer  "mentor_id"
    t.boolean  "mentor",                 default: false
  end

  add_index "users", ["cohort_id"], name: "index_users_on_cohort_id", using: :btree

  add_foreign_key "activities", "quizzes"
  add_foreign_key "quiz_submissions", "quizzes"
  add_foreign_key "quiz_submissions", "users"
end
