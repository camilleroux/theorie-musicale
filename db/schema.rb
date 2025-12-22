# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2015_08_28_010101) do
  create_table "chord_qualities", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "slug"
    t.index ["slug"], name: "index_chord_qualities_on_slug"
  end

  create_table "chord_scales", force: :cascade do |t|
    t.integer "chord_id"
    t.integer "mode_id"
    t.integer "offset", default: 0, null: false
    t.integer "strength", default: 1
    t.text "information"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chord_id"], name: "index_chord_scales_on_chord_id"
    t.index ["mode_id"], name: "index_chord_scales_on_mode_id"
  end

  create_table "chord_symbols", force: :cascade do |t|
    t.integer "chord_id"
    t.string "name"
    t.boolean "case_sensitive", default: false
    t.integer "strength"
    t.boolean "primary", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chord_id"], name: "index_chord_symbols_on_chord_id"
    t.index ["name"], name: "index_chord_symbols_on_name"
  end

  create_table "chords", force: :cascade do |t|
    t.integer "chord_quality_id"
    t.integer "parent_id"
    t.string "name"
    t.text "synonyms"
    t.text "information"
    t.string "tone_values", limit: 4000
    t.integer "chord_tones_count", default: 0
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["chord_quality_id"], name: "index_chords_on_chord_quality_id"
    t.index ["parent_id"], name: "index_chords_on_parent_id"
    t.index ["slug"], name: "index_chords_on_slug"
  end

  create_table "modes", force: :cascade do |t|
    t.integer "scale_id"
    t.integer "mode"
    t.string "name"
    t.text "synonyms"
    t.integer "dissonance"
    t.text "information"
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["mode"], name: "index_modes_on_mode"
    t.index ["scale_id"], name: "index_modes_on_scale_id"
    t.index ["slug"], name: "index_modes_on_slug"
  end

  create_table "scales", force: :cascade do |t|
    t.string "name"
    t.string "information"
    t.integer "symmetry_index"
    t.string "tone_values", limit: 4000
    t.integer "tones_count", default: 0
    t.string "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["slug"], name: "index_scales_on_slug"
  end
end
