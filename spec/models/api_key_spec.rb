# frozen_string_literal: true
require 'rails_helper'
describe ApiKey do
  context '.valid_token?' do
    subject { described_class.valid_token?(token) }
    let(:token) { 'ApiToken' }
    context 'when api token is present' do
      before { FactoryBot.create(:api_key, token: 'ApiToken') }
      it { is_expected.to be true }
    end
    context 'when api token is not present' do
      it { is_expected.to be false }
    end
  end
end
