require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    ActionMailer::Base.deliveries.clear
  end

  test "password reset" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    #アドレスが無効
    post password_resets_path, params:{password_reset:{email: ""}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #アドレスが有効
    post password_resets_path, params:{password_reset:{email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_not flash.empty?
    assert_redirected_to root_url
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url

    #パスワード再設定のフォームのテストeditビュー
    user = assigns(:user)
    #メールに添付された再設置のリンクのアドレスが無効
    get edit_password_reset_path(user.reset_token, email:"")
    assert_redirected_to root_url
    #有効化されていないユーザー無効なユーザー
    user.toggle!(:activated) #ブール値を反転
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    #アドレスが有効でトークンが無効
    get edit_password_reset_path('wrong token', email: user.email)
    assert_redirected_to root_url
    #アドレスもトークンも有効
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name= email][type= hidden][value=?]", user.email #隠しフィールドにemailがあるか
    #パスワードと確認が無効
    patch password_reset_path(user.reset_token), params:{email: user.email, #隠しフィールドのemailを送る
                                              user:{password: "foobaz",
                                                password_confirmation: "acvdf"}}
    #パスワードが空
    patch password_reset_path(user.reset_token), params:{email: user.email,
                                              user:{password:"",
                                                password_confirmation: ""}}
    assert_select 'div.error_explanation'
    #パスワードも確認も有効
    patch password_reset_path(user.reset_token), params:{email: user.email,
                                              user:{password: "foobar",
                                                password_confirmation: "foobar"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user_path(user)
  end

  test "expired token" do
    get new_password_reset_path
    post password_resets_path, params:{password_reset:{email: @user.email}}
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token), params:{email: @user.email,
                                              user:{password: "foobar",
                                                password_confirmation: "foobar"}}
    assert_redirected_to new_password_reset_url
  end

end
