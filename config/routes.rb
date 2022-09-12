Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  get 'categories' => 'store#categories'

  namespace :admin do
    get 'reports'
  end
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users do
    collection do
      get 'orders'
      get 'line_items'
    end
  end
  resources :orders
  resources :line_items
  resources :carts

  root 'store#index', as: 'store_index'

  resources :products do
    get :who_bought, on: :member
  end

  resources :support_requests, only: [ :index, :update ]
end
