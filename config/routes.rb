# frozen_string_literal: true

Rails.application.routes.draw do
  root 'items#index'
  resources :items do
    member do
      patch :toggle
    end
    collection do
      post :reorder
    end
  end
end
