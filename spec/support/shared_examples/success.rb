# frozen_string_literal: true
RSpec.shared_examples 'Successfully Created' do |object|
  let(:subject_body) { subject.body }
  let(:subject_status) { subject.status }
  let(:response_body) { {} }

  it 'responds with 201 code' do
    expect(subject_status).to eq(201)
  end

  it "returns created #{object} in response" do
    expect(subject_body).to eq(response_body)
  end
end
