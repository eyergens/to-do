class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :title
      t.string :description
      t.boolean :status
      t.integer :order
      t.timestamps
    end
  end
end
