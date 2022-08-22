class ChangeDiscountPriceColumnOfProducts < ActiveRecord::Migration[7.0]
  def change
    change_column :products, :discount_price, :decimal, precision: 8, scale: 2
  end
end
