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
    assert_redirected_to user_url(@user)
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    delete logout_path
    follow_redirect!
    assert_template 'static_pages/home'
    assert_not is_logged_in?
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
    delete logout_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", user_path(@user), count: 0
    assert_select "a[href=?]", logout_path, count: 0
  end

  test "login with remembering" do 
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token'] #テスト内ではキーの代わりに文字列を使う
  end

  test "login without remembering" do
    log_in_as(@user, remember_me: '1')
    delete logout_path
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end
end
