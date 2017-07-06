# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :categories, only: %i[index create update destroy] do
      get :tree, on: :collection
    end
  end

  root to: 'admin/categories#index'
end
