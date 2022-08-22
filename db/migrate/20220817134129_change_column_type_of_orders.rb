class ChangeColumnTypeOfOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :name, :text
  end
end
