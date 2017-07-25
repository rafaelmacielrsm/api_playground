require 'api_constraints'
Rails.application.routes.draw do
  # Api Definition
  namespace :api,
            constraints: { subdomain: 'api' },
            path: '/' do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      devise_for :users, controllers: { sessions: 'api/v1/sessions'}
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :products, only: [:create, :update, :destroy]
      end
      resources :sessions, only: [:create, :destroy]
      resources :products, only: [:show, :index]
    end
  end

end
