Rails.application.routes.draw do
  namespace :admin do
    get 'categories/index'
  end

  namespace :admin do
    get 'categories/show'
  end

  namespace :admin do
    get 'categories/new'
  end

  namespace :admin do
    get 'categories/create'
  end

  namespace :admin do
    get 'categories/edit'
  end

  namespace :admin do
    get 'categories/update'
  end

  namespace :admin do
    get 'categories/destroy'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
