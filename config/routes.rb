# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      namespace 'job_seeker' do
      end
      resources :test
      get 'status', to: 'base#status'
      resources :users
    end
  end
  resources :auth, only: %i[login] do
    post :login, on: :collection
  end
end
