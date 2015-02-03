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

ActiveRecord::Schema.define(version: 20150203005518) do

  create_table "results", force: true do |t|
    t.integer  "attention"
    t.integer  "sleep"
    t.integer  "distraction"
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.boolean  "professor",       default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
  end

  create_table "video_sessions", force: true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.string   "state"
    t.integer  "code",       limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", force: true do |t|
    t.integer  "owner_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "duration",   default: 0
    t.string   "title",      default: "Unknown"
    t.string   "link"
  end

  create_table "wave_logs", force: true do |t|
    t.datetime "timestamp"
    t.string   "body"
  end

  create_table "waves", force: true do |t|
    t.datetime "timestamp"
    t.integer  "wave0"
    t.integer  "wave1"
    t.integer  "wave2"
    t.integer  "wave3"
    t.integer  "wave4"
    t.integer  "wave5"
    t.integer  "wave6"
    t.integer  "wave7"
    t.integer  "attention"
    t.integer  "meditation"
    t.integer  "blink"
    t.integer  "quality"
    t.integer  "video_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
