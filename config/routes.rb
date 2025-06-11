Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: "pages#home"

  get "projects/list", to: "projects#list", as: :list_projects
  resources :projects
  resources :project_dates
  resources :clients
  resources :invoices do
    collection do
      get :preview
    end
  end
end
