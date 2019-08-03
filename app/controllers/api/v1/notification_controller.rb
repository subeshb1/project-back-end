# frozen_string_literal: true

module Api
  module V1
    class NotificationController < BaseController
      before_action :authenticate_request!

      def index
        render json: { notifications: current_user.notifications.order(created_at: :desc) }, status: :ok
      end

      def unread_count
        render json: { count: current_user.notifications.unread.count }, status: :ok
      end

      def show
        notification = current_user.notifications.where(id: params[:id]).last
        notification.status = 1
        notification.save!
        render json: notification.reload, status: :ok
      end
    end
  end
end
