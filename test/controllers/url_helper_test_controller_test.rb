require 'test_helper'

class UrlHelperTestControllerTest < ActionController::TestCase
  test "should get url_test" do
    get :url_test
    assert_response :success
  end

end
