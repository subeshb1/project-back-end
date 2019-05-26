source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'devise'
gem 'cancancan'
gem 'rake'

# Manage databases by mapping the tables to Ruby classes
gem 'activerecord'

# Query web services through api and examine the resulting output
gem 'httparty'

gem 'active_model_serializers'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use Puma as the app server
gem 'puma', '~> 3.11'
gem 'jwt'
gem 'travis'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test, :production do
    # Call `byebug` in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  # Call `binding.pry` in the code to access runtime developer console for debugging
  gem 'pry'
  # Extend pry by adding 'step' and 'next' commands for navigation
  gem 'pry-nav'
  # Extend pry to be used as rails console for debugging
  gem 'pry-rails'
  # Achieve static analysis of your Ruby code to get a quality report for it
  gem 'rubycritic', require: false
  # Detect security vulnerabilities in Ruby on Rails applications via static analysis
  gem 'brakeman', require: false
end

group :development,:production do
  gem 'annotate'
   # Get notified about the file modifications made
  gem 'listen'
  # Speed up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  # Achieve functionalities of listen with spring
  gem 'spring-watcher-listen'
  # Check code style to enforce the community-driven Ruby Style Guide
  gem 'rubocop', require: false
  # Extend rubocop to check rspec files as well
  gem 'rubocop-rspec'
  gem 'rubocop-performance'
  # For easy renaming of your project
  # gem 'rename'
end

group :test do
  # Code coverage analysis tool for Ruby
  gem 'simplecov', require: false
  gem 'rspec-rails'
  gem 'database_cleaner'
  # Add :retry option for intermittently failing rspec examples
  # gem 'rspec-retry'
  # set ruby objects as test data with support for multiple factories for the same class
  gem 'factory_bot_rails'
  # easily generate fake data
  gem 'rack-test', require: 'rack/test'
  gem 'rspec-rails'

  gem 'faker'
  # Select from many strategies for cleaning your database in Ruby,
  # especially to ensure a clean state during tests
  # For more understandable, maintainable Rails-specific tests
  gem 'shoulda'
  # Use time travel capabilities to easily test time-dependent code
  # gem 'timecop'
  # Use for stubbing and setting expectations on HTTP requests
  # gem 'webmock', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
