# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace 'api' do
    namespace 'v1' do
      namespace 'jobprovider' do
        resources :job
      end
      resources :profile, only: %i[index show] do
        put :basic_info, on: :collection
        put :education, on: :collection
        put :work_experience, on: :collection
        get :status, on: :collection
        get 'basic_info', to: 'profile#show_basic_info', on: :collection
        get 'education', to: 'profile#show_education', on: :collection
        get 'work_experience', to: 'profile#show_work_experience', on: :collection
      end
      resources :test, only: [:index]
      get 'status', to: 'base#status'
      resources :users, only: [:create] do
        get :role, on: :collection
      end
      resources :applicant, only: %i[create show] do
        post :apply, on: :member
        post :approve, on: :member
        post :reject, on: :member
        get :view_applied, on: :collection
      end

      resources :notification, only: [:index] do
        get :unread_count, on: :collection
        get :show, on: :member
      end

      resources :jobs, only: %i[show index] do
        get :recommend, on: :collection
      end

      resources :exams, only: %i[show index] do
        get :result, on: :member
        get :skills, on: :collection
      end
    end
  end
  resources :auth, only: %i[login] do
    post :login, on: :collection
  end
end
