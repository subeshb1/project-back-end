# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :profiles, only: [:index] do
        put :update, on: :collection
      end
      resources :test, only: [:index]
      get 'status', to: 'base#status'
      resources :users, only: [:create] do
        get :role, on: :collection
      end
    end
  end
  resources :auth, only: %i[login] do
    post :login, on: :collection
  end
end
