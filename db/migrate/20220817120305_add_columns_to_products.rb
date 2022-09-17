class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :enabled, :boolean, default: nil
    add_column :products, :discount_price, :decimal, precision: 8, scale: 2
    add_column :products, :permalink, :string
  end
end
