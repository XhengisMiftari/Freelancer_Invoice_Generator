Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'users/registrations' # <-- add this line
  }
  root to: "pages#home"
  get 'dashboard', to: 'pages#dashboard'
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
