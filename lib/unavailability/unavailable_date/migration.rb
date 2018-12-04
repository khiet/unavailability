class CreateUnavailableDates < ActiveRecord::Migration[5.2]
  def change
    create_table :unavailable_dates do |t|
      t.date    :from
      t.date    :to
      t.integer :datable_id
      t.string  :datable_type

      t.timestamps
    end

    add_index :unavailable_dates, [:datable_type, :datable_id]
  end
end
