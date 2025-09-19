# frozen_string_literal: true

Rails.application.routes.draw do
  root 'items#index'
  resources :items

  post 'items/:id/toggle', to: 'items#toggle'
  post 'items/reorder', to: 'items#reorder'
end
