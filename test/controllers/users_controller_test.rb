require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "redirect loginurl when try edit without logged in " do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "redirect loginurl when try update without logged in" do
    patch user_path(@user), params:{user:{name: @user.name,
                                      email: @user.email,}}
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } } 
    assert_redirected_to root_url
  end

  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_path
  end

  test "successful access to index when looged in" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
  end

  test "should not allow the admin attribute to be edit via the web" do
    log_in_as(@other_user) #なぜ@other_userか、@userをa管理者dminにしているから
    assert_not @other_user.admin?
    patch user_path(@other_user), params:{user:{password: "password",
                      password_confirmation: "password", admin: true}}
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_path
  end

  test "should redirect destroy when logged in  as a not admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "success destroy when logged in as a admin" do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
    assert_redirected_to root_url
  end
end
