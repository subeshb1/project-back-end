# frozen_string_literal: true

module Api
  module V1
    class TestController < BaseController
      before_action :authenticate_request!

      def index
        render json: { data: 'Hello' }, status: 200
      end
    end
  end
end
