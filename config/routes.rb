Rails.application.routes.draw do
  get 'admin' => 'admin#index'
  
  # Mapping custom routes to actions in sessions controller
  controller :sessions do
    # both login mapped to :new and :create method
    # only difference is type of request being GET and POST
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :users
  resources :orders
  resources :line_items
  resources :carts
  
  # Creating Store as Root URL of App 
  # as: option creates store_index_path and store_index_url methods for tests
  # store#index specifying class and method to use for action request
  root 'store#index', as: 'store_index'

  resources :products do
    get :who_bought, on: :member
  end

  resources :support_requests, only: [ :index, :update ]

end
