# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      resources :test
      get 'status', to: 'base#status'
    end
  end
  resources :auth, only: %i[login] do
    post :login, on: :collection
  end
end
