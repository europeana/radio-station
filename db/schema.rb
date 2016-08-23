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

ActiveRecord::Schema.define(version: 20160823084048) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "playlists", force: :cascade do |t|
    t.integer  "station_id"
    t.boolean  "live",       default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "playlists_tracks", id: false, force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "track_id"
    t.index ["playlist_id"], name: "index_playlists_tracks_on_playlist_id", using: :btree
    t.index ["track_id"], name: "index_playlists_tracks_on_track_id", using: :btree
  end

  create_table "stations", force: :cascade do |t|
    t.string   "name"
    t.text     "api_query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tracks", force: :cascade do |t|
    t.string   "europeana_id"
    t.string   "web_resource_uri"
    t.json     "metadata"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["europeana_id", "web_resource_uri"], name: "index_tracks_on_europeana_id_and_web_resource_uri", unique: true, using: :btree
    t.index ["europeana_id"], name: "index_tracks_on_europeana_id", using: :btree
    t.index ["web_resource_uri"], name: "index_tracks_on_web_resource_uri", using: :btree
  end

  add_foreign_key "playlists", "stations"
end
