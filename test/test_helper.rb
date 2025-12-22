ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers (disabled for now to avoid seed conflicts)
  # parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Load seeds before tests
  setup do
    if Scale.count == 0
      load "#{Rails.root}/db/seeds.rb"
    end
  end
end
