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

ActiveRecord::Schema.define(version: 20170329170034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "countries", force: :cascade do |t|
    t.string   "name_en",                                  null: false
    t.string   "country_code",                             null: false
    t.integer  "population"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "has_confirmed_signatures", default: false
    t.string   "name_ar"
    t.string   "name_ms"
    t.string   "name_bn"
    t.string   "name_bg"
    t.string   "name_cs"
    t.string   "name_sr"
    t.string   "name_zh"
    t.string   "name_de"
    t.string   "name_es"
    t.string   "name_el"
    t.string   "name_fa"
    t.string   "name_fr"
    t.string   "name_he"
    t.string   "name_hi"
    t.string   "name_hr"
    t.string   "name_is"
    t.string   "name_it"
    t.string   "name_ja"
    t.string   "name_ko"
    t.string   "name_lv"
    t.string   "name_hu"
    t.string   "name_nl"
    t.string   "name_pl"
    t.string   "name_pt"
    t.string   "name_ro"
    t.string   "name_ru"
    t.string   "name_fi"
    t.string   "name_sv"
    t.string   "name_th"
    t.string   "name_vi"
    t.string   "name_tr"
    t.index ["country_code"], name: "index_countries_on_country_code", unique: true, using: :btree
    t.index ["name_ar"], name: "index_countries_on_name_ar", using: :btree
    t.index ["name_bg"], name: "index_countries_on_name_bg", using: :btree
    t.index ["name_bn"], name: "index_countries_on_name_bn", using: :btree
    t.index ["name_cs"], name: "index_countries_on_name_cs", using: :btree
    t.index ["name_de"], name: "index_countries_on_name_de", using: :btree
    t.index ["name_el"], name: "index_countries_on_name_el", using: :btree
    t.index ["name_en"], name: "index_countries_on_name_en", using: :btree
    t.index ["name_es"], name: "index_countries_on_name_es", using: :btree
    t.index ["name_fa"], name: "index_countries_on_name_fa", using: :btree
    t.index ["name_fi"], name: "index_countries_on_name_fi", using: :btree
    t.index ["name_fr"], name: "index_countries_on_name_fr", using: :btree
    t.index ["name_he"], name: "index_countries_on_name_he", using: :btree
    t.index ["name_hi"], name: "index_countries_on_name_hi", using: :btree
    t.index ["name_hr"], name: "index_countries_on_name_hr", using: :btree
    t.index ["name_hu"], name: "index_countries_on_name_hu", using: :btree
    t.index ["name_is"], name: "index_countries_on_name_is", using: :btree
    t.index ["name_it"], name: "index_countries_on_name_it", using: :btree
    t.index ["name_ja"], name: "index_countries_on_name_ja", using: :btree
    t.index ["name_ko"], name: "index_countries_on_name_ko", using: :btree
    t.index ["name_lv"], name: "index_countries_on_name_lv", using: :btree
    t.index ["name_ms"], name: "index_countries_on_name_ms", using: :btree
    t.index ["name_nl"], name: "index_countries_on_name_nl", using: :btree
    t.index ["name_pl"], name: "index_countries_on_name_pl", using: :btree
    t.index ["name_pt"], name: "index_countries_on_name_pt", using: :btree
    t.index ["name_ro"], name: "index_countries_on_name_ro", using: :btree
    t.index ["name_ru"], name: "index_countries_on_name_ru", using: :btree
    t.index ["name_sr"], name: "index_countries_on_name_sr", using: :btree
    t.index ["name_sv"], name: "index_countries_on_name_sv", using: :btree
    t.index ["name_th"], name: "index_countries_on_name_th", using: :btree
    t.index ["name_tr"], name: "index_countries_on_name_tr", using: :btree
    t.index ["name_vi"], name: "index_countries_on_name_vi", using: :btree
    t.index ["name_zh"], name: "index_countries_on_name_zh", using: :btree
  end

  create_table "signatures", force: :cascade do |t|
    t.string   "name",                              null: false
    t.string   "email",                             null: false
    t.string   "place"
    t.string   "country_code",                      null: false
    t.string   "state",         default: "pending", null: false
    t.string   "signing_token"
    t.string   "ip_address"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["email"], name: "index_signatures_on_email", unique: true, using: :btree
    t.index ["signing_token"], name: "index_signatures_on_signing_token", unique: true, using: :btree
    t.index ["state", "country_code", "place"], name: "index_signatures_on_state_and_country_code_and_place", using: :btree
  end

end
