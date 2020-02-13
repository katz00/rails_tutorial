require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should delete logout" do
    delete logout_path
    assert_not is_logged_in?
  end

end
