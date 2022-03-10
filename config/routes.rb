Rails.application.routes.draw do
  # Api definition
  namespace :api, defaults: { format: :json } do
    # list of resources
    namespace :v1 do
      devise_for :users
      resources :users, only: [:show, :create, :update, :destroy]
    end
  end
end
