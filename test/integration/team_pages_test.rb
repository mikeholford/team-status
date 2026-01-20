require "test_helper"

class TeamPagesTest < ActionDispatch::IntegrationTest
  test "creates a team and shows keys" do
    post teams_path, params: { team: { name: "My Team" } }

    assert_response :created
    assert_includes response.body, "Public key"
    assert_includes response.body, "Secret key"
  end

  test "shows team page by uuid" do
    get team_path(teams(:one))

    assert_response :success
    assert_includes response.body, "Test Team"
    assert_includes response.body, "alice"
  end
end
