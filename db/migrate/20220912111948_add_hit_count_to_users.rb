class AddHitCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :hit_count, :integer, default: 0
  end
end
