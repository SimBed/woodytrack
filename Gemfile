source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'

gem 'bcrypt'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'bootstrap'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'faker'
# RuboCop Faker is a tool for converting Faker methods to the latest Faker argument style with static code analysis.
gem 'rubocop-faker'
gem 'jbuilder', '~> 2.7'
gem 'jquery-rails'
gem 'pg'
gem 'puma', '~> 3.11'
gem 'sass-rails', '>= 6'
gem 'terser'
gem 'will_paginate', '3.1.7'
gem 'coffee-rails', '~> 5.0.0'
gem 'rails', '~> 6.0.3', '>= 6.0.3.4'
gem 'rubocop-rails'
gem 'turbolinks', '~> 5'
# https://stackoverflow.com/questions/67773514/getting-warning-already-initialized-constant-on-assets-precompile-at-the-time
gem "net-http"


group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rails-controller-testing'
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'webdrivers'  
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
