# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    namespace :admin do
      resources :categories, only: %i[index create update destroy] do
        get :tree, on: :collection
      end
    end

    resources :categories, only: %i[index show]

    get '/', to: 'categories#index', as: :home
  end

  root to: 'categories#index'
end
