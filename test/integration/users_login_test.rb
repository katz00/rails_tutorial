require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    ##usersはymlファイル,その中のmichaelのデータを:michaelというシンボルで参照する
    @user = users(:michael)
  end

  test "login with invalid infomation" do
    get login_path
    assert_template 'sessions/new'
    post login_path params:{session:{email:"",password:""}}
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information and log out" do
    get login_path
    assert_template 'sessions/new'
    post login_path params:{session:{email: @user.email,
                              password:"password"}}
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end
end
