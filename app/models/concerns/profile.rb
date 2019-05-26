# frozen_string_literal: true

module Profile
  extend ActiveSupport::Concern
  included do
    def self.find_user(id)
      where(user_id: id).last
    end

    def user
      User.find(user_id)
    end
  end
end
