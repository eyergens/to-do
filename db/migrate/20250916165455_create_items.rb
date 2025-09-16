class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :title, null: false
      t.string :description
      t.boolean :status, null: false, default: 0
      t.integer :order, null: false
      t.timestamps
    end
  end
end
