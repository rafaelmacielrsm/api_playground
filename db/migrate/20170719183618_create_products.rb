class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :title, default: ""
      t.decimal :price, precision: 8, scale: 2, default: 0.0
      t.boolean :published, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
