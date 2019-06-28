# frozen_string_literal: true

require 'rails_helper'

describe Recommendation do
  let(:user) do
    FactoryBot.create(:user)
  end

  before do
    20.times.each { FactoryBot.create(:job) }
  end

  describe '.pearson_correlation_score' do
    subject { described_class.pearson_correlation_score(user, other_user) }

    let(:other_user) do
      FactoryBot.create(:user)
    end
    context 'when the user has no job views' do
      it 'has 0 correlation score' do
        expect(subject).to eq(0.0)
      end
    end

    context 'when user has views and other user has none' do
      before do
        Job.first(10).each do |job|
          user.viewed_jobs << job
        end
      end

      it 'has 0 correlation score' do
        expect(subject).to eq(0.0)
      end
    end

    context 'when user and other users have common views but not applied any job' do
      before do
        Job.first(10).each do |job|
          user.viewed_jobs << job
          other_user.viewed_jobs << job
        end
      end

      it 'has 0 correlation score' do
        expect(subject).to eq(0.0)
      end
    end

    context 'when user and other user have common views and one or more some has applied job' do
      before do
        create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, nil], user)
        create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0, 0, 1, 0, nil, 0, 1, 0, nil, 0], other_user)
      end

      it 'shows correlation score of the users' do
        expect(subject).to eq(0.8018)
      end
    end
  end

  describe '.user_based_recommendation' do
    subject { described_class.user_based_recommendation(user) }
    let(:user2) { FactoryBot.create(:user) }
    let(:user3) { FactoryBot.create(:user) }
    let(:user4) { FactoryBot.create(:user) }
    let(:user5) { FactoryBot.create(:user) }

    context 'when there are no users activity' do
      it 'no jobs are recommended' do
        expect(subject).to eq([])
      end
    end

    context 'when user has no activity but the group does' do
      before { create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0, 0, 1, 0], user2) }

      it 'no jobs are recommended' do
        expect(subject).to eq([])
      end
    end

    context 'when user and group have some activity' do
      context 'but there are no similar users' do
        before do
          create_view_apply_jobs([nil, nil, nil, nil, nil, nil, 0, 0, 1, 0], user)
          create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0], user2)
          create_view_apply_jobs([1, 1, 0, 0, 1, 1, nil], user3)
        end
        it 'no jobs are recommended' do
          expect(subject).to eq([])
        end
      end

      context 'and there are some similar users' do
        context 'but there are no other jobs activity for other user' do
          before do
            create_view_apply_jobs([1, 0, 1, 0, 1, 0, 0, 0, 1, 0], user)
            create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0], user2)
            create_view_apply_jobs([1, 1, 0, 0, 1, 1, nil], user3)
          end
          it 'no jobs are recommended' do
            expect(subject).to eq([])
          end
        end
        context 'and there are other ativities of similar users' do
          before do
            create_view_apply_jobs([1, 0, 1, 0, 1, 0, 0, nil, nil], user)
            create_view_apply_jobs([1, 0, 0, 0, 1, 1, 0,   1, 1, nil], user2)
            create_view_apply_jobs([1, 1, 0, 0, 1, 1, nil, 0, nil, 0], user3)
            create_view_apply_jobs([1, 1, 1, 0, 1, 1, nil, 0, 1, 0], user4)
          end
          it 'jobs are recommended' do
            expect(subject.pluck(:score)).to eq([{ id: 9, score: 2.0 }, { id: 8, score: 1.4823 },
                                   { id: 10, score: 1.0 }].pluck(:score))
          end
        end
      end
    end
  end
end

def create_view_apply_jobs(job_array, user)
  job_array.each_with_index do |val, index|
    user.viewed_jobs << Job.all[index] if val
    user.applied_jobs << Job.all[index] if val == 1
  end
end
