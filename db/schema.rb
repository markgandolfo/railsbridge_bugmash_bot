# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

  create_table "people", :force => true do |t|
    t.string   "name"
    t.integer  "chats_count", :default => 0
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "assigned-user-id"
    t.integer  "attachments-count"
    t.text     "body"
    t.text     "body-html"
    t.datetime "created-at"
    t.integer  "creator-id"
    t.integer  "milestone-id"
    t.integer  "number"
    t.string   "permalink"
    t.integer  "project_id"
    t.string   "state"
    t.string   "title"
    t.datetime "updated-at"
    t.integer  "user_id"
    t.text     "tag"
  end

end
