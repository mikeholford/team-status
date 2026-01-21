require "test_helper"

class Api::V1::StatusUpdatesTest < ActionDispatch::IntegrationTest
  test "creates a status update" do
    assert_difference("StatusUpdate.count", 1) do
      post api_v1_team_status_updates_path,
        params: { username: "bob", status: "Out for lunch" },
        headers: auth_headers
    end

    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "bob", json.fetch("status_update").fetch("username")
    assert_equal "Out for lunch", json.fetch("status_update").fetch("status")
  end

  test "creates a status update with expires" do
    expires = 1.hour.from_now.iso8601

    post api_v1_team_status_updates_path,
      params: { username: "bob", status: "Deep work", expires: expires },
      headers: auth_headers

    assert_response :created
    json = JSON.parse(response.body)

    returned_expires = Time.iso8601(json.fetch("status_update").fetch("expires_at"))
    assert_in_delta Time.iso8601(expires).to_f, returned_expires.to_f, 0.001
  end

  test "rejects expires in the past" do
    post api_v1_team_status_updates_path,
      params: { username: "bob", status: "Deep work", expires: 1.minute.ago.iso8601 },
      headers: auth_headers

    assert_response :unprocessable_entity
  end

  test "returns not_found if user missing" do
    post api_v1_team_status_updates_path,
      params: { username: "nope", status: "Hello" },
      headers: auth_headers

    assert_response :not_found
  end

  test "returns unauthorized with wrong secret" do
    post api_v1_team_status_updates_path,
      params: { username: "bob", status: "Hello" },
      headers: {
        "X-Team-Public-Key" => teams(:one).public_key,
        "X-Team-Secret-Key" => "wrong"
      }

    assert_response :unauthorized
  end

  private

  def auth_headers
    {
      "X-Team-Public-Key" => teams(:one).public_key,
      "X-Team-Secret-Key" => "secret_test_1"
    }
  end
end
