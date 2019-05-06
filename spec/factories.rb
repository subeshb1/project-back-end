# frozen_string_literal: true
FactoryBot.define do
  factory :api_key do
    token {'1ic3Xb1K84uifO82CL5F'}
    app_info { { app_name: 'consumer_app' } }
  end
end
