class CreateCompetitions < ActiveRecord::Migration[6.1]
  def change
    create_table :competitions do |t|
      t.string :name
      t.date :date
      t.string :location
      t.string :country
      t.string :distance_type

      t.timestamps
    end
  end
end
