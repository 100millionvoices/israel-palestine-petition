class CreateSignatures < ActiveRecord::Migration[5.0]
  def change
    create_table :signatures do |t|
      t.string   :name, null: false
      t.string   :email, null: false
      t.string   :place
      t.string   :country_code, null: false
      t.string   :state, default: 'pending', null: false
      t.string   :signing_token
      t.string   :ip_address
      t.timestamps
    end

    add_index :signatures, :email, unique: true
    add_index :signatures, :signing_token, unique: true
    add_index :signatures, [:state]
  end
end
