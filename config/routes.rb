Rails.application.routes.draw do
  namespace :admin do
    resources :categories
  end

  root to: 'admin/categories#index'
end
