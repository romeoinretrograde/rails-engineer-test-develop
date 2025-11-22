Rails.application.routes.draw do
  root "companies#index"
  
  resources :companies, only: [:index] do
    collection do
      get :admin
      post :import
    end
  end
end