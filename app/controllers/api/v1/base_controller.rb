# frozen_string_literal: true
module Api
  module V1
    # Base controller for all V1 APIs
    class BaseController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      def status
        render json: { message: 'App is up and running' }.to_json
      end

      # bottom-up order for exception is needed
      rescue_from StandardError, with: :handle_exception
      rescue_from APIError, with: :handle_api_error

      protected

      def api_error(code, msg = '', request = nil)
        raise APIError.new(code, msg, request)
      end

      def handle_api_error(excp)
        render excp.render_json
      end

      def handle_exception(excp)
        binding.pry
        render APIError.new(500, '', request, excp).render_json
      end

      def authenticate
        api_error(401, '', request) unless valid_token?
      end

      def valid_token?
        token = request.env['HTTP_X_API_TOKEN']
        ApiKey.valid_token?(token)
      end

      # Schema Validation
      def validate_schema
        controller_params = { controller_name: controller_name, action_name: action_name }
        valid, error = SchemaValidatorForm.new(params, controller_params).validate
        api_error(422, JSON.parse(error.message)) unless valid
      end
    end
  end
end
