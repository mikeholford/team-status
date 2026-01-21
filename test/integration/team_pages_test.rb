require "test_helper"

class TeamPagesTest < ActionDispatch::IntegrationTest
  test "creates a team and shows the team page" do
    post teams_path, params: { team: { name: "My Team" } }

    assert_response :see_other
    follow_redirect!

    assert_response :success
    assert_includes response.body, "My Team"
    assert_includes response.body, "Add user"
  end

  test "creates a team without a name" do
    post teams_path, params: { team: { name: "" } }

    assert_response :see_other
    follow_redirect!

    assert_response :success
    assert_includes response.body, "My Team"
  end

  test "shows team page by uuid" do
    get team_path(teams(:one))

    assert_response :success
    assert_includes response.body, "Test Team"
    assert_includes response.body, "alice"
  end
end
