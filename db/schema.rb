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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110202204610) do

  create_table "games", :force => true do |t|
    t.integer  "number"
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.integer  "original_odds"
    t.integer  "adjusted_odds"
  end

  create_table "odds", :force => true do |t|
    t.integer  "seed_one"
    t.integer  "seed_two"
    t.integer  "chance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "odds", ["seed_one", "seed_two"], :name => "by_seed_one_and_seed_two", :unique => true

  create_table "participants", :force => true do |t|
    t.integer  "game_id"
    t.integer  "team_id"
    t.boolean  "winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plural_name"
  end

  add_index "tags", ["name", "kind"], :name => "by_name_and_kind", :unique => true

  create_table "tags_teams", :id => false, :force => true do |t|
    t.integer "team_id"
    t.integer "tag_id"
  end

  add_index "tags_teams", ["tag_id", "team_id"], :name => "by_tag_and_team", :unique => true

  create_table "tags_tournaments", :id => false, :force => true do |t|
    t.integer "tournament_id"
    t.integer "tag_id"
  end

  add_index "tags_tournaments", ["tournament_id", "tag_id"], :name => "by_tournament_and_tag", :unique => true

  create_table "tags_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "tag_id"
  end

  add_index "tags_users", ["tag_id", "user_id"], :name => "by_tag_and_user", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "mascot"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seed"
    t.integer  "division_seed"
    t.string   "division"
    t.string   "short_name"
  end

  create_table "tournaments", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "team_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
