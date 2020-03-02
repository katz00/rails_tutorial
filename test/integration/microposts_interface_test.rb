require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    #assert_select '.paginate'
    #無効なマイクロポストを送信
    assert_no_difference 'Micropost.count' do
      post microposts_path, params:{micropost:{content:""}}
    end
    assert_select "div.error_explanation"
    #有効なマイクロポスト
    content = "This a test micropost"
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params:{micropost:{content: content}}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    #マイクロポストを削除する
    assert_select 'a', text:'delete'
    first_micropost = @user.microposts.page(1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    #別のユーザーのマイクロポストにdeleteリンクが表示されていないことの確認
    get user_path(users(:archer))
    assert_select 'a', text:'delete', count: 0
  end

  test "micropost sidebar count" do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    #まだマイクロポストを投稿していないユーザー
    other_user = users(:malory)
    log_in_as(other_user)
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "A first micropost")
    get root_path
    assert_match "1 micropost", response.body
  end

end
