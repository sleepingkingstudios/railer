# spec/rails_helper.rb

ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/sleeping_king_studios/all'
require 'rspec/sleeping_king_studios/examples/active_model/validation_examples'
require 'rspec/sleeping_king_studios/examples/action_controller/response_examples'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.extend RSpec::SleepingKingStudios::Concerns::FocusExamples
  config.extend RSpec::SleepingKingStudios::Concerns::WrapExamples

  # Automatically mix in different behaviours to your tests based on their file
  # location.
  config.infer_spec_type_from_file_location!
end # configure
