Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations'
  }
  root to: "pages#home"

  get "dashboard/invoices", to: "pages#invoices",  as: :dashboard_invoices
  get "dashboard/clients",  to: "pages#clients",   as: :dashboard_clients
  get "dashboard/projects", to: "pages#projects",  as: :dashboard_projects

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
  end
end
