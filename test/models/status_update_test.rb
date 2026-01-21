require "test_helper"

class StatusUpdateTest < ActiveSupport::TestCase
  test "requires status" do
    update = StatusUpdate.new(team: teams(:one), team_user: team_users(:alice))
    refute update.valid?
    assert_includes update.errors[:status], "can't be blank"
  end

  test "expires_at must be in the future" do
    update = StatusUpdate.new(
      team: teams(:one),
      team_user: team_users(:alice),
      status: "Hello",
      expires_at: 1.minute.ago
    )

    refute update.valid?
    assert_includes update.errors[:expires_at], "must be in the future"
  end

  test "team must match team_user.team" do
    other_team = Team.create!(name: "Other")
    update = StatusUpdate.new(team: other_team, team_user: team_users(:alice), status: "Hello")

    refute update.valid?
    assert_includes update.errors[:team_id], "must match team_user.team_id"
  end
end
