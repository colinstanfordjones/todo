class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.string :description
      t.integer :position
      t.boolean :status
      t.timestamps
    end

    add_reference :line_items, :todo_lists, foreign_key: true
  end
end
