# frozen_string_literal: true

Dir[File.expand_path('../abilities/*.rb', __FILE__)].each { |file| require file }

# Athorization for the user class according to their roles.
class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    if user
      User::ROLES.values.each do |role|
        ability = "#{role}_ability"
        extend ability.camelize.constantize
      end
      send(user.nice_role, user)
    end
  end
end
