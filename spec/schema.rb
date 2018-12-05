ActiveRecord::Schema.define do
  self.verbose = false

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unavailable_dates", force: :cascade do |t|
    t.date "from"
    t.date "to"
    t.string "dateable_type"
    t.bigint "dateable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dateable_type", "dateable_id"], name: "index_unavailable_dates_on_dateable_type_and_dateable_id"
  end
end
