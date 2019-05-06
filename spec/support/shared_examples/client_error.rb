# frozen_string_literal: true
RSpec.shared_examples 'Validation Failure' do
  let(:subject_status) { subject.status }
  let(:parsed_subject) { Requests::JsonHelpers.json_body(subject) }
  let(:message) { 'Validation Failed' }
  let(:error_block) { [] }

  it 'responds with 422 code' do
    expect(subject_status).to eq(422)
  end

  it 'responds with validation failed error message' do
    expect(parsed_subject['message']).to eq(message)
  end

  it 'responds with fieldwise error message block' do
    expect(parsed_subject['errors']).to eq(error_block.map(&:with_indifferent_access))
  end
end

# 400 Error
RSpec.shared_examples 'Resource not found' do |resource|
  let(:error_message) { '' }
  let(:subject_status) { subject.status }
  let(:parsed_subject) { Requests::JsonHelpers.json_body(subject) }

  it 'responds with 404 code' do
    expect(subject_status).to eq(404)
  end

  it "responds with #{resource} not found error" do
    expect(parsed_subject['message']).to eq(error_message)
  end
end
