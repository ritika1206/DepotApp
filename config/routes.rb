class RestrictedBrowserRequest
  def self.matches?(request)
    request.headers['User-Agent'] !~ BROWSER_REGEX
  end
end

Rails.application.routes.draw do
  constraints(RestrictedBrowserRequest) do
    root 'store#index', as: 'store_index'

    get 'admin' => 'admin#index'

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

    resources :categories, constraints: { id: POSITIVE_INTEGER_REGEX }, only: :index  do
      get :books, on: :member
    end
    get 'categories/*path', to: redirect('/')

    resources :support_requests, only: [ :index, :update ]
  end
  get '/' => 'store#index'
  match '/*path', via: :all, to: redirect('/404')
end
