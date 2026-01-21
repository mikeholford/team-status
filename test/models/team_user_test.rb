require "test_helper"

class TeamUserTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

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

  test "current_status is nil when last update expired" do
    user = team_users(:bob)

    start_time = Time.current

    travel_to start_time do
      user.status_updates.create!(team: teams(:one), status: "BRB", expires_at: 1.minute.from_now)
    end

    travel_to(start_time + 2.minutes) do
      assert_nil user.current_status
      assert user.last_status_update.present?
    end
  end
end
