# frozen_string_literal: true
require 'rails_helper'

describe Api::V1::UsersController, type: :api do
  before do
    api_key = FactoryBot.create(:api_key)
    header 'x-api-token', api_key.token
    header 'Content-type', 'application/json'
  end

  describe '#create' do
    subject { post 'api/v1/users', params.to_json }
    let(:base_params) do 
      {
        email: 'example@gmail.com',
        password: '12345678',
        confirm_password: '12345678',
        type: 'job_seeker'
      }
    end
    context 'when required params are not provided' do
      let(:params) { {} }

      include_examples 'Validation Failure' do
        let(:errors) do
          [
            { field: 'type', message: 'is missing' },
            { field: 'email', message: 'is missing' },
            { field: 'password', message: 'is missing' },
            { field: 'confirm_password', message: 'is missing' },
          ]
        end
      end
    end
  end
end
