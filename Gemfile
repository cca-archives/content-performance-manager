source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

# GOV.UK gems and forks
gem 'gds-api-adapters'
gem 'gds-sso'
gem 'govspeak'
gem 'govuk_admin_template'
gem 'govuk_app_config'
gem 'govuk_sidekiq'
gem 'plek'

gem "html_to_plain_text"

# Third party gems
gem 'activerecord-import'
gem 'draper'
gem 'feature'
gem 'google-api-client', '~> 0.9'
gem 'httparty'
gem 'jbuilder'
gem 'jquery-rails'
gem 'kaminari'
gem 'logstasher'
gem 'pg'
gem 'puma'
gem 'rack-proxy'
gem 'rails', '~> 5.1'
gem 'sass-rails'
gem 'selectize-rails'
gem 'turbolinks'
gem 'uglifier'
gem 'unicorn'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'
end

group :test do
  # This is a dependency for Teaspoon and a known issue
  # See https://github.com/jejacks0n/teaspoon/issues/405
  gem 'coffee-script'
end

group :development, :test do
  gem 'active_record_disabler'
  gem 'byebug'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'govuk-lint', '~> 3.2'
  gem 'guard-rspec', require: false
  gem 'listen'
  gem 'phantomjs'
  gem 'poltergeist'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'simplecov', require: false
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen'
  gem 'teaspoon-jasmine'
  gem 'timecop'
  gem 'webmock'
end


# firebreak
gem "readingtime"
gem "odyssey"
gem "rack-cors"
gem "redcarpet"