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

ActiveRecord::Schema[8.1].define(version: 2026_04_09_224550) do
  create_table "driver_records", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date_of_birth", null: false
    t.string "driving_licence_number", null: false
    t.string "driving_licence_type", null: false
    t.string "first_names", null: false
    t.string "last_name", null: false
    t.datetime "updated_at", null: false
    t.index ["driving_licence_number"], name: "index_driver_records_on_driving_licence_number", unique: true
  end
end
