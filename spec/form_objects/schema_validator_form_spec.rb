# frozen_string_literal: true
require 'rails_helper'

describe SchemaValidatorForm do
  describe '#validate' do
    subject(:schema_validator) do
      described_class.new(params, controller_params).validate
    end

    let(:controller_params) do
      {
        controller_name: 'templates',
        action_name: 'create'
      }
    end

    context 'when provided parameters satisfy schema validation' do
      let(:params) do
        {
          'field_name': 'template'
        }.with_indifferent_access
      end

      it 'returns validation as true' do
        expect(schema_validator).to eq([true, nil])
      end
    end

    context 'when provided parameters does not satisfy schema validation' do
      subject(:error_state) { schema_validator[0] }
      subject(:err_message) { schema_validator[1].message }

      let(:params) do
        {
          'field_name': ['template']
        }.with_indifferent_access
      end
      let(:error_message) do
        { message: 'Validation Failed',
          errors: [{
            field: 'field_name',
            message: 'of type array did not match the following type: string'
          }] }.to_json
      end

      it 'returns validation as false along with error message' do
        expect(error_state).to eq(false)
        expect(err_message).to eq(error_message)
      end
    end
  end
end
