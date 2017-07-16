# frozen_string_literal: true

Rails.application.routes.draw do
  get 'categories/show'

  namespace :admin do
    resources :categories, only: %i[index create update destroy] do
      get :tree, on: :collection
    end
  end

  resources :categories, only: %i[index show]

  root to: 'categories#index'
end
