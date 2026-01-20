require "test_helper"

class Api::V1::StatusesTest < ActionDispatch::IntegrationTest
  test "requires authentication" do
    get api_v1_team_status_path
    assert_response :unauthorized
  end

  test "returns current team statuses" do
    get api_v1_team_status_path, headers: auth_headers

    assert_response :success
    json = JSON.parse(response.body)

    assert_equal "Test Team", json.fetch("team").fetch("name")
    alice = json.fetch("users").find { |u| u.fetch("username") == "alice" }

    assert_equal "Going for a walk", alice.fetch("status")
    assert alice.fetch("updated_at").present?
  end

  private

  def auth_headers
    {
      "X-Team-Public-Key" => teams(:one).public_key,
      "X-Team-Secret-Key" => "secret_test_1"
    }
  end
end
