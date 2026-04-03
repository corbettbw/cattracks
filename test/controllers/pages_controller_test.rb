require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get tos" do
    get pages_tos_url
    assert_response :success
  end

  test "should get privacy_policy" do
    get pages_privacy_policy_url
    assert_response :success
  end

  test "should get support" do
    get pages_support_url
    assert_response :success
  end
end
