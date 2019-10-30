class CreateTrips < ActiveRecord::Migration[6.0]
  def change
    create_table :trips do |t|
      t.references :user, null: false, foreign_key: true
      t.string :departure_station
      t.string :arrival_station
      t.datetime :from_date
      t.datetime :to_date
      t.boolean :searching

      t.timestamps
    end
  end
end
