ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# Reference data (scales, modes, chords) is loaded once, outside of the per-test transactions
Rails.application.load_seed if Scale.none?

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers (disabled for now to avoid seed conflicts)
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
end
