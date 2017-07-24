# frozen_string_literal: true

require 'rails_helper'
require 'capybara'

Capybara.javascript_driver = :webkit
Capybara.server = :puma

RSpec.configure do |config|
  config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }
  config.before(:each)  { DatabaseCleaner.strategy = :transaction }
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }
end
