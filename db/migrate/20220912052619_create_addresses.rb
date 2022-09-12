class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :state
      t.string :city
      t.string :country
      t.integer :pincode, limit: 6

      t.timestamps
    end
  end
end
