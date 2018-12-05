ActiveRecord::Schema.define do
  self.verbose = false

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table :unavailable_dates, force: :cascade do |t|
    t.date "from"
    t.date "to"
    t.integer "datable_id"
    t.string "datable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["datable_type", "datable_id"], name: "index_unavailable_dates_on_datable_type_and_datable_id"
  end
end
