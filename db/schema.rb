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

ActiveRecord::Schema.define(version: 20170626175631) do

  create_table "posts", force: :cascade do |t|
    t.string   "p_id"
    t.string   "p_writer"
    t.text     "p_message"
    t.datetime "p_time"
    t.integer  "p_reactions_count"
    t.integer  "p_likes_count"
    t.integer  "p_loves_count"
    t.integer  "p_hahas_count"
    t.integer  "p_wows_count"
    t.integer  "p_sads_count"
    t.integer  "p_angrys_count"
    t.string   "c1_id"
    t.string   "c1_name"
    t.text     "c1_message"
    t.string   "c1_attachment"
    t.datetime "c1_time"
    t.integer  "c1_reactions_count"
    t.integer  "c1_likes_count"
    t.integer  "c1_loves_count"
    t.integer  "c1_hahas_count"
    t.integer  "c1_wows_count"
    t.integer  "c1_sads_count"
    t.integer  "c1_angrys_count"
    t.string   "c2_id"
    t.string   "c2_name"
    t.text     "c2_message"
    t.string   "c2_attachment"
    t.datetime "c2_time"
    t.integer  "c2_reactions_count"
    t.integer  "c2_likes_count"
    t.integer  "c2_loves_count"
    t.integer  "c2_hahas_count"
    t.integer  "c2_wows_count"
    t.integer  "c2_sads_count"
    t.integer  "c2_angrys_count"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "c1_profile"
    t.string   "c2_profile"
  end

end
