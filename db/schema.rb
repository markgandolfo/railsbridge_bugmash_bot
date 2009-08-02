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

ActiveRecord::Schema.define(:version => 2) do

  create_table "people", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "people_tickets", :force => true do |t|
    t.integer  "person_id"
    t.integer  "ticket_id"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "assigned_user_id"
    t.integer  "attachments_count"
    t.text     "body"
    t.text     "body_html"
    t.integer  "creator_id"
    t.integer  "milestone_id"
    t.integer  "number"
    t.string   "permalink"
    t.integer  "project_id"
    t.string   "state"
    t.string   "title"
    t.integer  "user_id"
    t.text     "tag"
    t.datetime "cached_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
