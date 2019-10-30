require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get stations" do
    get api_stations_url
    assert_response :success
  end

end
