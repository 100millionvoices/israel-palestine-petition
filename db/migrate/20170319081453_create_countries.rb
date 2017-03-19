class CreateCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :countries do |t|
      t.string   :name, null: false
      t.string   :country_code, null: false
      t.integer  :population
      t.timestamps
    end

    add_index :countries, :country_code, unique: true
  end
end
