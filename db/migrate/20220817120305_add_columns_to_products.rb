class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :enabled, :boolean, default: nil
    add_column :products, :discount_price, :decimal
    add_column :products, :permalink, :string
  end
end
