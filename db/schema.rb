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

ActiveRecord::Schema.define(version: 20180807081243) do

  create_table "inquiries", force: :cascade do |t|
    t.string "email"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "keywords", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_keywords", force: :cascade do |t|
    t.integer "service_id"
    t.integer "keyword_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_service_keywords_on_keyword_id"
    t.index ["service_id"], name: "index_service_keywords_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "url"
    t.string "domain"
    t.string "title"
    t.text "description"
    t.string "favicon"
    t.string "ogpimg"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
