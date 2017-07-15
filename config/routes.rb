# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :categories, only: %i[index create update destroy] do
      get :tree, on: :collection
    end
  end

  resources :articles, only: [:index]

  root to: 'articles#index'
end
