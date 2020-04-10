require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /api/v1/todo' do
    before do
      @todo = FactoryBot.create(:to_do)
      @line_items = FactoryBot.create_list :line_item, 3, to_do: @todo
      get '/api/v1/todo'
    end
  
    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns the line items' do
      line_items = JSON.parse(response.body)["results"]
      expect(line_items.count).to eq ToDo.find(@todo.id).line_items.count
    end
  end

  describe 'PUT /api/v1/todo' do
    before do
      @todo = FactoryBot.create(:to_do)
      @line_items = FactoryBot.create_list :line_item, 3, to_do: @todo
      @updated_todo = @line_items[1..2].map{ |i| { id: i.id, title: i.title, completed: i.completed } }
      put '/api/v1/todo', params: { line_items: @updated_todo }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'associated line items are updated' do
      expect(ToDo.find(@todo.id).line_items.count).to eq @updated_todo.count
    end
  end
end

