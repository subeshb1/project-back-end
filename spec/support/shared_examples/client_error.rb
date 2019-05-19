# frozen_string_literal: true

RSpec.shared_examples 'Validation Failure' do
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }
  let(:error_message) { 'Validation Failed' }
  let(:errors) { [] }

  it 'responds with 422 code' do
    expect(subject_status).to eq(422)
  end

  it 'responds with validation failed error message' do
    expect(parsed_body['message']).to eq(error_message)
  end

  it 'responds with fieldwise error message block' do
    expect(parsed_body['errors']).to eq(errors.map(&:with_indifferent_access))
  end
end

# Partial Validation Error
RSpec.shared_examples 'Partial message in Validation Failure' do
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }
  let(:error_message) { 'Validation Failed' }
  let(:error_block) { {} }

  it 'responds with 422 code' do
    expect(subject_status).to eq(422)
  end

  it 'responds with validation failed error message' do
    expect(parsed_body['message']).to eq(error_message)
  end

  it 'responds with fieldwise error message block' do
    expect(parsed_body['errors']).to include(JSON.parse(error_block.to_json))
  end
end

# 400 Error
RSpec.shared_examples 'Resource not found' do |resource|
  let(:error_message) { '' }
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }

  it 'responds with 404 code' do
    expect(subject_status).to eq(404)
  end

  it "responds with #{resource} not found error" do
    expect(parsed_body['message']).to eq(error_message)
  end
end

# 403 Error
RSpec.shared_examples 'Action Forbidden' do
  let(:error_message) { '' }
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }

  it 'responds with 403 code' do
    expect(subject_status).to eq(403)
  end

  it 'responds with forbidden error' do
    expect(parsed_body['message']).to eq(error_message)
  end
end

# 500 Error
RSpec.shared_examples 'Internal Server Error' do
  let(:error_message) { 'Internal server error' }
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }

  it 'responds with 500 code' do
    expect(subject_status).to eq(500)
  end

  it 'responds with internal server error' do
    expect(parsed_body['message']).to eq(error_message)
  end
end

# 409 Error
RSpec.shared_examples 'Conflict' do
  let(:subject_body) { subject.body }
  let(:subject_status) { subject.status }
  let(:parsed_body) { subject.parsed_body }

  it 'responds with 409 code' do
    expect(subject_status).to be(409)
  end

  it 'responds with already exists error' do
    expect(parsed_body['message']).to eql(error_message)
  end
end
