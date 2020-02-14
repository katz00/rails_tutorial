require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    #fixtureはDBにテストデータを流し込むもの、当然パスワード属性は持っていない。
    #仮にymlファイルでパスワード属性を書いたら、DBにそんなカラムは無い！と怒られる。
    #なので更新に成功するテストを通すために
    #そのユーザーが登録済みの場合のみ(未登録なら弾かれる)パスワードの値が空でもバリデーションをスキップできるallow_nil: trueを
    #パスワードの存在性の検証に追加する。
    #でもだったら編集フォームにパスワードいらなくね？
  end

  test "update with invalid information" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params:{ user: {name:"",email: "",
              password:"bar", password_confirmation:"foo"}}
    assert_template 'users/edit'
    assert_select "div.alert", "The form contains 5 errors"
  end

  test "update with valid information" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    #更新するために使った値と更新後の値を下で比較検証するために変数に入れておく
    patch user_path(@user), params:{user:{name: name,
                              email: email,
                              password:"",
                              password_confirmation:""}}
    assert_not flash.empty?
    follow_redirect!
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
