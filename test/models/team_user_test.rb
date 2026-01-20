require "test_helper"

class TeamUserTest < ActiveSupport::TestCase
  test "requires username" do
    user = TeamUser.new(team: teams(:one))
    refute user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "requires unique username per team" do
    dupe = TeamUser.new(team: teams(:one), username: team_users(:alice).username)
    refute dupe.valid?
    assert_includes dupe.errors[:username], "has already been taken"
  end

  test "current_status returns latest status" do
    assert_equal "Going for a walk", team_users(:alice).current_status
  end
end
