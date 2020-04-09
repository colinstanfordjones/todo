# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get :todo, to: 'todo#index'
      put :todo, to: 'todo#update'
    end
  end
end
