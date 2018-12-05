class CreateUnavailableDates < ActiveRecord::Migration[5.2]
  def change
    create_table :unavailable_dates do |t|
      t.date    :from
      t.date    :to
      t.references :datable, polymorphic: true

      t.timestamps
    end
  end
end
