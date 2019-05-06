# frozen_string_literal: true
# Validate Response body Example
RSpec.shared_examples 'Validate Response Body' do |example|
  let(:response_body) { {} }
  let(:subject_body) { subject.body }

  it example.to_s do
    expect(subject_body).to eq(response_body.to_json)
  end
end

# Validate Status code Example
RSpec.shared_examples 'Validate Status Code' do |code|
  let(:subject_status) { subject.status }

  it "returns #{code} status code" do
    expect(subject_status).to eq(code.to_i)
  end
end
