require "application_system_test_case"

class WelcomesTest < ApplicationSystemTestCase
  test "visiting the welcome page" do
    visit root_url
    assert_selector "a.navbar-brand", text: "Théorie musicale"
  end
end
