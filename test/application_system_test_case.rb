require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # Muted: the play buttons tests would otherwise sound on the speakers
  driven_by :selenium, using: :headless_chrome do |options|
    options.add_argument("--mute-audio")
  end
end
