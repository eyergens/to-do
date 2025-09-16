# frozen_string_literal: true

Rails.application.routes.draw do
  # root to: 'items#index'
  get 'items', to: 'items#index'
  post '/items/:id', to: 'items#create'
  put 'items/:id', to: 'items#update'
  delete 'items/:id', to: 'items#destroy'
end
