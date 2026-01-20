require "test_helper"

class Api::V1::TeamUsersTest < ActionDispatch::IntegrationTest
  test "lists users" do
    get api_v1_team_team_users_path, headers: auth_headers

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal 2, json.fetch("users").size
    assert_equal "alice", json.fetch("users").first.fetch("username")
  end

  test "creates a user" do
    assert_difference("TeamUser.count", 1) do
      post api_v1_team_team_users_path,
        params: { team_user: { username: "charlie", profile_pic_url: "https://example.com/c.png" } },
        headers: auth_headers
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "charlie", json.fetch("user").fetch("username")
  end

  test "rejects invalid user" do
    post api_v1_team_team_users_path, params: { team_user: { username: "" } }, headers: auth_headers

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json.fetch("errors"), "Username can't be blank"
  end

  private

  def auth_headers
    {
      "X-Team-Public-Key" => teams(:one).public_key,
      "X-Team-Secret-Key" => "secret_test_1"
    }
  end
end
