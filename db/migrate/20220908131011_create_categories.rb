class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :products_count
      t.integer :total_products_count
      t.references :parent, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
