Rails.application.routes.draw do
  root 'store#index', as: 'store_index'

  get 'admin' => 'admin#index'
  get 'categories' => 'store#categories'
  get 'categories/:id/books' => 'categories#books', as: :category_books, constraint: { id: /\d+/ }
  get 'categories/:id/books', to: redirect('/')

  namespace :admin do
    get 'reports'
    get 'categories'
  end
  
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users do
    collection do
      get 'my-orders', action: :orders
      get 'my-items', action: :line_items
    end
  end
  resources :orders
  resources :line_items
  resources :carts

  
  resources :products, path: :books do
    get :who_bought, on: :member
  end
  
  resources :support_requests, only: [ :index, :update ]
end
