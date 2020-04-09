require 'test_helper'

class FollowingsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end

  test "following page" do
    get followings_user_path(@user)
    assert_not @user.followings.empty?
    assert_match @user.followings.count.to_s, response.body
    @user.followings.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end

  test "followers page" do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select "a[href=?]", user_path(user)
    end
  end
end
