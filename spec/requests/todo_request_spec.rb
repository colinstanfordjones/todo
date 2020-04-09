require 'rails_helper'

RSpec.describe 'Homes', type: :request do
  describe 'GET /api/v1/todo' do
    it 'returns http success' do
      get '/api/v1/todo'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /api/v1/todo' do
    it 'returns http success' do
      put '/api/v1/todo'
      expect(response).to have_http_status(:success)
    end
  end
end

