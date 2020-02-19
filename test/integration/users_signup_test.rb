require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup with invalid information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params:{user:{name:"", email:"",
              password:"", password_confirmation:""}}
    end
    assert_template 'users/new'
    assert_select 'div .error_explanation'
    assert_select 'div .alert'
  end

  test "valid signup informatin with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: {name:"Example User", email:"user@example.com",
              password:"password", password_confirmation:"password"}}
    end
    assert_equal 1, ActionMailer::Base.deliveries.size #送信したメールが一通
    user = assigns(:user)
    assert_not user.activated?
    log_in_as(user) #有効化しないでログイン
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token", email: user.email) #無効なトークンで有効化を試みる
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: 'worng') #無効なアドレスで有効化を試みる
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email) #正しい有効化
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

end
