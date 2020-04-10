require 'rails_helper'

RSpec.describe ToDo, type: :model do
  context 'Updating LineItems' do
    todo = FactoryBot.create(:to_do)
    line_items = FactoryBot.create_list :line_item, 3, to_do: todo

    it 'ToDo#update_line_items! Should update line items based on the LineItems passed' do
      updated_line_items = todo.line_items[0..1]
      todo.update_line_items!(updated_line_items)

      expect(todo.line_items.count).to eq updated_line_items.count
    end

    it 'ToDo#update_line_items! Should update associated line items' do
      updated_line_item = line_items[0]
      updated_line_item.completed = true
      updated_line_items = [updated_line_item, *line_items[1..2]]
      
      todo.update_line_items!(updated_line_items)

      expect(LineItem.find(updated_line_item[:id]).completed).to eq true
    end
  end
end
