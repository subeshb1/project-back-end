# frozen_string_literal: true

FactoryBot.define do
  factory :api_key do
    token { '1ic3Xb1K84uifO82CL5F' }
    app_info { { app_name: 'consumer_app' } }
  end

  factory :user do
    email { Faker::Internet.email }
    role { User::ROLES.key('job_seeker') }
    password {'12345678'}
  end

  factory :job_provider, class: User do
    email { Faker::Internet.email }
    role { User::ROLES.key('job_provider') }
    password {'12345678'}
  end

  factory :job do
    job_title { Faker::Job.title }
    association :user, factory: :job_provider
  end
end
