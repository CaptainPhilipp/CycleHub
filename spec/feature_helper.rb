require 'spec_helper'
require 'capybara/poltergeist'

Capybara.javascript_driver = :poltergeist
Capybara.server = :puma

# For debug
#
# Capybara.register_driver :poltergeist_debug do |app|
#   Capybara::Poltergeist::Driver.new(app, :inspector => true)
# end
#
# Capybara.javascript_driver = :poltergeist_debug

RSpec.configure do |config|
  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
end
