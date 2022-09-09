class AddCategoryRefToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :category_id, :integer, null: false
    add_foreign_key :products, :categories
  end
end
