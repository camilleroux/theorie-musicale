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

ActiveRecord::Schema.define(version: 20150828010101) do

  create_table "chord_qualities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "slug"
  end

  add_index "chord_qualities", ["slug"], name: "index_chord_qualities_on_slug"

  create_table "chord_scales", force: :cascade do |t|
    t.integer  "chord_id"
    t.integer  "mode_id"
    t.integer  "offset",      default: 0, null: false
    t.integer  "strength",    default: 1
    t.text     "information"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chord_scales", ["chord_id"], name: "index_chord_scales_on_chord_id"
  add_index "chord_scales", ["mode_id"], name: "index_chord_scales_on_mode_id"

  create_table "chord_symbols", force: :cascade do |t|
    t.integer  "chord_id"
    t.string   "name"
    t.boolean  "case_sensitive", default: false
    t.integer  "strength"
    t.boolean  "primary",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chord_symbols", ["chord_id"], name: "index_chord_symbols_on_chord_id"
  add_index "chord_symbols", ["name"], name: "index_chord_symbols_on_name"

  create_table "chords", force: :cascade do |t|
    t.integer  "chord_quality_id"
    t.integer  "parent_id"
    t.string   "name"
    t.text     "synonyms"
    t.text     "information"
    t.string   "tone_values",       limit: 4000
    t.integer  "chord_tones_count",              default: 0
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chords", ["chord_quality_id"], name: "index_chords_on_chord_quality_id"
  add_index "chords", ["parent_id"], name: "index_chords_on_parent_id"
  add_index "chords", ["slug"], name: "index_chords_on_slug"

  create_table "modes", force: :cascade do |t|
    t.integer  "scale_id"
    t.integer  "mode"
    t.string   "name"
    t.text     "synonyms"
    t.integer  "dissonance"
    t.text     "information"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "modes", ["mode"], name: "index_modes_on_mode"
  add_index "modes", ["scale_id"], name: "index_modes_on_scale_id"
  add_index "modes", ["slug"], name: "index_modes_on_slug"

  create_table "scales", force: :cascade do |t|
    t.string   "name"
    t.string   "information"
    t.integer  "symmetry_index"
    t.string   "tone_values",    limit: 4000
    t.integer  "tones_count",                 default: 0
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scales", ["slug"], name: "index_scales_on_slug"

end
