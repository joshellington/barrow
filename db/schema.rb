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

ActiveRecord::Schema.define(version: 20141030193548) do

  create_table "collections", force: true do |t|
    t.string   "uid"
    t.integer  "user_id"
    t.string   "dropbox_path"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "title"
  end

  create_table "items", force: true do |t|
    t.string   "path"
    t.string   "rev"
    t.string   "client_mtime"
    t.string   "icon"
    t.integer  "bytes"
    t.string   "modified"
    t.string   "size"
    t.string   "root"
    t.string   "mime_type"
    t.integer  "revision"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "collection_id"
    t.string   "public_path"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "display_name"
    t.integer  "dropbox_uid"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "access_token"
  end

end
