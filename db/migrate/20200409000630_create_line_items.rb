# frozen_string_literal: true

##
# LineItem migration
class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.string :title
      t.boolean :completed, default: false
      t.timestamps
    end

    add_reference :line_items, :to_do, foreign_key: true
  end
end
