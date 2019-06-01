# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ENV['URL'] = 'http://localhost:4000'

ENV['URL'] = 'https://final-project-trinity.herokuapp.com' if Rails.env.production?
