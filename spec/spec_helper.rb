# frozen_string_literal: true

if ENV['TRAVIS'] == 'true'
  require 'coveralls'
  Coveralls.wear!
end

require 'simplecov-shield'

ASSETS_PATH = File.expand_path('assets', __dir__)

RSpec.configure do |config|
  # Spec Filtering
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Output
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
