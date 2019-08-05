# frozen_string_literal: true

class Notification < ApplicationRecord
  STATUS = {
    'unread' => 0,
    'read' => 1
  }.freeze
  belongs_to :user
  scope :unread, -> { where(:status => 0)}
  # Ex:- scope :active, -> {where(:active => true)}
end
