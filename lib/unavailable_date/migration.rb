class CreateUnavailableDates < ActiveRecord::Migration["#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}"]
  def change
    create_table :unavailabilities do |t|
      t.date :from
      t.date :to

      t.timestamps null: false
    end
  end
end
