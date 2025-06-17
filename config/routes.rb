Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  root to: "pages#home"
  get "dashboard/invoices", to: "pages#invoices",  as: :dashboard_invoices  # links to the dashboard cards in home.html.erb
  get "dashboard/clients",  to: "pages#clients",   as: :dashboard_clients   # links to the dashboard cards in home.html.erb
  get "dashboard/projects", to: "pages#projects",  as: :dashboard_projects  # links to the dashboard cards in home.html.erb
  # we arrive at dashboard after the GET from dash_controller.js -> activates the methods in pagesController ("to: "pages#invoices"") -> pages_controller.rb
  resources :projects do
    collection do
      get :list
    end
  end
  resources :project_dates
  resources :clients do
    collection do
      get :list
    end
  end
  resources :invoices do
    collection do
      get :preview
      get :list
      get :new_frame
    end
    member do
      post :create_checkout_session
    end
  end

  post '/stripe/webhook', to: 'stripe_webhooks#receive'
end
