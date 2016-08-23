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

ActiveRecord::Schema.define(version: 20160823133334) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "origins", force: :cascade do |t|
    t.string   "europeana_record_id"
    t.json     "metadata"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["europeana_record_id"], name: "index_origins_on_europeana_record_id", unique: true, using: :btree
  end

  create_table "playlists", force: :cascade do |t|
    t.integer  "station_id"
    t.boolean  "live",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.text     "api_query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "slug"
    t.index ["slug"], name: "index_stations_on_slug", unique: true, using: :btree
  end

  create_table "tracks", force: :cascade do |t|
    t.integer  "tune_id"
    t.integer  "playlist_id"
    t.integer  "order",       null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["order"], name: "index_tracks_on_order", using: :btree
    t.index ["playlist_id"], name: "index_tracks_on_playlist_id", using: :btree
    t.index ["tune_id"], name: "index_tracks_on_tune_id", using: :btree
  end

  create_table "tunes", force: :cascade do |t|
    t.integer  "origin_id"
    t.string   "web_resource_uri"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["origin_id"], name: "index_tunes_on_origin_id", using: :btree
    t.index ["web_resource_uri"], name: "index_tunes_on_web_resource_uri", unique: true, using: :btree
  end

  add_foreign_key "playlists", "stations"
end
