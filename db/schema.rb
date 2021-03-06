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

ActiveRecord::Schema.define(version: 20140418220528) do

  create_table "app_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.string   "github_uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "github_login"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id"

  create_table "project_app_types", force: true do |t|
    t.integer  "project_id"
    t.integer  "app_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_app_types", ["app_type_id"], name: "index_project_app_types_on_app_type_id"
  add_index "project_app_types", ["project_id"], name: "index_project_app_types_on_project_id"

  create_table "project_images", force: true do |t|
    t.string   "image"
    t.boolean  "primary_image"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_images", ["project_id"], name: "index_project_images_on_project_id"

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "live_app_url"
    t.string   "screenshot_path"
    t.string   "brief_description"
    t.text     "longer_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_id"
    t.string   "display_name"
    t.string   "technologies"
  end

  create_table "user_projects", force: true do |t|
    t.integer  "user_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_projects", ["project_id"], name: "index_user_projects_on_project_id"
  add_index "user_projects", ["user_id"], name: "index_user_projects_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "twitter_handle"
    t.string   "linkedin_url"
    t.string   "avatar_url"
    t.text     "bio"
    t.boolean  "hireable"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "github_login"
    t.boolean  "display"
  end

end
