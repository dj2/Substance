# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'rails', '~> 6.1.4', '>= 6.1.4.1'

gem 'acts-as-taggable-on', '~> 8.0'
gem 'nokogiri'
gem 'paper_trail'
gem 'redcarpet'
gem 'reverse_markdown'

gem 'octicons'

group :development do
  gem 'rubocop-rails', require: false
  gem 'yard', require: false
end

group :test do
  gem 'factory_bot_rails'
end
