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

ActiveRecord::Schema[8.1].define(version: 2026_01_21_064400) do
  create_table "status_updates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.text "status", null: false
    t.integer "team_id", null: false
    t.integer "team_user_id", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_status_updates_on_expires_at"
    t.index ["team_id"], name: "index_status_updates_on_team_id"
    t.index ["team_user_id", "created_at"], name: "index_status_updates_on_team_user_id_and_created_at"
    t.index ["team_user_id"], name: "index_status_updates_on_team_user_id"
  end

  create_table "team_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "profile_pic_url"
    t.integer "team_id", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["team_id", "username"], name: "index_team_users_on_team_id_and_username", unique: true
    t.index ["team_id"], name: "index_team_users_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "public_key", null: false
    t.string "secret_key_digest", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["public_key"], name: "index_teams_on_public_key", unique: true
    t.index ["uuid"], name: "index_teams_on_uuid", unique: true
  end

  add_foreign_key "status_updates", "team_users"
  add_foreign_key "status_updates", "teams"
  add_foreign_key "status_updates", "teams"
  add_foreign_key "team_users", "teams"
  add_foreign_key "team_users", "teams"
end
