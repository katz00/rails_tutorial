require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @relationship = @user.active_relationships.build(follower_id: @user.id,
                                      following_id: @other_user.id)
  end

  test "should be valid" do
    assert @relationship.valid?
  end

  test "should require a follower_id" do
    @relationship.follower_id = nil
    assert_not @relationship.valid?
  end

  test "should require a following_id" do
    @relationship.following_id = nil
    assert_not @relationship.valid?
  end
end
