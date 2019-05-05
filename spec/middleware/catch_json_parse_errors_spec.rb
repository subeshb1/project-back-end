# frozen_string_literal: true
require 'rails_helper'
describe CatchJsonParseErrors do
  subject(:post_request) do
    request.post('/', input: post_data, 'CONTENT_TYPE' => 'application/json')
  end
  let(:app) { proc { [200, {}, ['Hello, world.']] } }
  let(:stack) { described_class.new(app) }
  let(:request) { Rack::MockRequest.new(stack) }
  context 'when invalid JSON request body' do
    let(:post_data) do
      '{
        "name": "Entity name",
        "description": "Entity description",
        "resource": {
          "name": "resource_name
        }
      }'
    end

    it 'returns problem parsing body message' do
      expect(post_request.body).to eq({ message: 'Problem parsing the body' }.to_json)
    end

    it 'returns 400 status code' do
      expect(post_request.status).to eq(400)
    end
  end

  context 'when valid JSON request body' do
    let(:post_data) do
      '{
        "name": "Entity name",
        "description": "Entity description",
        "resource": {
          "name": "resource_name"
        }
      }'
    end
    it 'responds with 200' do
      expect(post_request.status).to eq(200)
    end
    it 'responds with valid body' do
      expect(post_request.body).to eq('Hello, world.')
    end
  end
end
