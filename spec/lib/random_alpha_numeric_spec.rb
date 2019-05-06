# frozen_string_literal: true
require 'rails_helper'

describe RandomAlphaNumeric do
  # Define dummy Random UID class from RandomAlphaNumeric
  class RandomUID
    include RandomAlphaNumeric
    attr_accessor :uid

    def has_attribute?(field)
    end

    def write_attribute(field, random_id)
    end

    def self.exists?(_field)
    end
  end

  describe '#assign_unique_id' do
    let(:random_uid) { RandomUID.new }

    context 'when the object is missing required attribute' do
      subject(:uid_assignment) { random_uid.assign_unique_id(field: :aid) }

      it 'raises Active Model Exception' do
        expect(random_uid).to receive(:has_attribute?)
          .with(:aid)
          .and_return(false)
        expect { uid_assignment }
          .to raise_error(ActiveModel::MissingAttributeError)
      end
    end

    context 'when the object has required attribute' do
      context 'and the attribute is already set' do
        before do
          random_uid.uid = 'random'
        end
        subject(:uid_assignment) { random_uid.assign_unique_id }

        it 'returns without generating new random id' do
          expect(random_uid).to receive(:has_attribute?)
            .with(:uid)
            .and_return(true)
          expect(SecureRandom).to receive(:alphanumeric)
            .never
          uid_assignment
        end
      end

      context 'and the attribute is not set' do
        context 'and the generated random uid already exist' do
          subject(:uid_assignment) { random_uid.assign_unique_id }
          let(:existing_uid) { '1234' }
          let(:new_uid) { '7890' }
          before do
            allow(random_uid).to receive(:has_attribute?)
              .with(:uid)
              .and_return(true)
            allow(SecureRandom).to receive(:alphanumeric)
              .and_return(existing_uid, new_uid)
            expect(RandomUID).to receive(:exists?)
              .with(uid: existing_uid)
              .and_return(true)
            expect(RandomUID).to receive(:exists?)
              .with(uid: new_uid)
              .and_return(false)
          end

          it 'retries until unique id is generated and assigns it to the attribute' do
            expect(SecureRandom).to receive(:alphanumeric)
              .at_least(:twice)
            expect(random_uid).to receive(:write_attribute)
              .with(:uid, new_uid).once
            uid_assignment
          end
        end

        context 'and generated random uid does not exist' do
          subject(:uid_assignment) { random_uid.assign_unique_id }
          let(:generated_uid) { '1234' }
          before do
            allow(random_uid).to receive(:has_attribute?)
              .with(:uid)
              .and_return(true)
            allow(SecureRandom).to receive(:alphanumeric)
              .and_return(generated_uid)
            allow(RandomUID).to receive(:exists?)
              .with(uid: generated_uid).and_return(false)
            expect(SecureRandom)
              .to receive(:alphanumeric).once
          end

          it 'assigns random uid to the attribute' do
            expect(random_uid).to receive(:write_attribute)
              .with(:uid, generated_uid).once
            uid_assignment
          end
        end
      end
    end
  end
end
