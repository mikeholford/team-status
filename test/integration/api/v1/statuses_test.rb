require "test_helper"

class Api::V1::StatusesTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

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

  test "returns status nil after it expires" do
    user = team_users(:alice)

    start_time = Time.current

    travel_to start_time do
      user.status_updates.create!(team: teams(:one), status: "BRB", expires_at: 1.minute.from_now)
    end

    travel_to(start_time + 2.minutes) do
      get api_v1_team_status_path, headers: auth_headers

      assert_response :success
      json = JSON.parse(response.body)
      alice = json.fetch("users").find { |u| u.fetch("username") == "alice" }

      assert_nil alice.fetch("status")
      assert alice.fetch("updated_at").present?
    end
  end

  private

  def auth_headers
    {
      "X-Team-Public-Key" => teams(:one).public_key,
      "X-Team-Secret-Key" => "secret_test_1"
    }
  end
end
