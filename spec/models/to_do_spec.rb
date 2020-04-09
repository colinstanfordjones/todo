require 'rails_helper'

RSpec.describe ToDo, type: :model do
  context 'Updating LineItems' do
    todo = FactoryBot.create(:to_do)

    it "ToDo#update_line_items! Should update line items based on the LineItems passed" do
      updated_line_items = todo.line_items[1..2]
      todo.update_line_items!(updated_line_items)

      expect(todo.line_items.count).to eq updated_line_items.count
    end
  end
end
