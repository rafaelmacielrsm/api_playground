class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.decimal :total, precision: 10, scale: 2

      t.timestamps
    end
  end
end
