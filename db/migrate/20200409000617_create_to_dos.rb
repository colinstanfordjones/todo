# frozen_string_literal: true

##
# LineItem migration
class CreateToDos < ActiveRecord::Migration[6.0]
  def change
    create_table :to_dos do |t|
      t.string :description
      t.timestamps
    end
  end
end
