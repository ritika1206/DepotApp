class AddCategoryRefToProducts < ActiveRecord::Migration[7.0]
  def change
    add_reference :products, :category, foreign_key: true, null: false
  end
end
