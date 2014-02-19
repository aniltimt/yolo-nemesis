MarketApi::Application.routes.draw do
  get '/login' => 'v1/market#login'
  match '/auth/:provider/callback' => 'v1/sessions#create'
  post 'sessions/create' => "v1/sessions#create"

  get "/users/return_token", :to => "v1/users#return_token",          :as => "users_return_token"
  get "/users/check_logged_in", :to => "v1/users#check_logged_in",    :as => "check_logged_in"

  devise_for :users, :controllers => {:registrations => "v1/registrations", :sessions => "v1/my_devise_sessions"}

  namespace :admin do
    match "login/change" => "login#change"
    match "logout" => "login#destroy"

    resources :login

    match "pobs/search", :to => "pobs#search"
    resources :pobs do
      resources :coupons
      resources :banners
    end
    match "pobs/coupons/search", :to => "coupons#search"
    match "pobs/banners/search", :to => "banners#search"
    match "pobs/remove_pob_image/:pob_image_id", :to => "pobs#remove_pob_image"

    match "tours/:type/show_tours/:page", :to => "tours#show_tours", :as => "tours_show_tours"
    match "tours/pending", :to => "tours#pending"
    match "tours/rebuild_bundles", :to => "tours#rebuild_bundles"
    resources :tours do
      member do
        post :free
        post :paid
        post :publish
        post :unpublish
      end
    end

    match "clients/:id/save_tours", :to => "clients#save_tours", :as => "clients_save_tours"
    match "clients/:id/generate_users", :to => "clients#generate_users", :as => "clients_generate_users"
    match "clients/:id/show_users/:page", :to => "clients#show_users", :as => "clients_show_users"

    match "clients/check_name_validity", :to => "clients#check_name_validity"
    match "clients/check_password_validity", :to => "clients#check_password_validity"
    match "clients/check_email_validity", :to => "clients#check_email_validity"

    match "clients/:id/download_csv_userlist(/:generation)", :to => "clients#download_csv_userlist", :as => "clients_download_csv_userlist"
    match "clients/:id/download_pdf_userlist(/:generation)", :to => "clients#download_pdf_userlist", :as => "clients_download_pdf_userlist"

    resources :clients

    match "users/:type/show_users/:page", :to => "users#show_users", :as => "users_show_users"
    
    resources :users do
      resources :orders
    end

    resource :dashboard

    resource :statistics, :only => [] do
      member do
        get :top_buyers
        get :top_popular_tours
      end
    end
    root :to => 'dashboard#index'
  end

  namespace :v1 do
    namespace :ios do
      resources :orders, :only => :create
    end
    namespace :android do
      resources :orders, :only => :create
    end
    
    resources :orders, :only => [:index, :show]
    resources :places, :only => :index
    resources :clients, :only => :index
    resources :pob_categories, :only => :index
  end

  get '/pobs/create_bundle' => "v1/pobs#create_bundle"
  get '/pobs/sync' => "v1/pobs#sync"

  get '/market/places/:country/:city.xml' => "v1/market#show",               :as => "market_country_city"
  get '/market/places/:country.xml' => "v1/market#show"
  get '/market/places.xml' => "v1/market#index"

  match "/products/map/:id.:format" => "v1/products#map",                    :as => "map_market_product"
  match "/products/media/:id.:format" => "v1/products#media",                :as => "media_market_product"
  match "/products/:id.:format" => "v1/products#show",                       :as => "market_product"

  root :to => "admin/dashboard#index"
end
