class IndexOnSignatures < ActiveRecord::Migration[5.0]
  def change
    remove_index :signatures, :state
    add_index :signatures, [:state, :country_code, :place]
  end
end
