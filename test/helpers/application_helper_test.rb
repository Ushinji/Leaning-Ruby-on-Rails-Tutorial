require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  # full_titleヘルパーに対するテスト
  test "full title helper" do
    assert_equal full_title, "Ruby on Rails Tutorial Sample App"
    assert_equal full_title("Help"), "Help | Ruby on Rails Tutorial Sample App"
  end
end
