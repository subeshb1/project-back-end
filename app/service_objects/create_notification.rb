# frozen_string_literal: true

class CreateNotification
  attr_accessor :user, :from, :to, :message
  def initialize(user, from, to, message)
    @user = user
    @from = from
    @to = to
    @message = message
  end

  def call
    user.notifications << Notification.create(from: from, to: to, message: message, status: 0)
  end
end
