require "test_helper"

class SightingsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sightings_new_url
    assert_response :success
  end

  test "should get create" do
    get sightings_create_url
    assert_response :success
  end

  test "should get destroy" do
    get sightings_destroy_url
    assert_response :success
  end
end
