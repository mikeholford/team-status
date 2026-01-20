require "test_helper"

class TeamTest < ActiveSupport::TestCase
  test "generates uuid, public_key, and secret_key_digest on create" do
    team = Team.new(name: "New Team")

    assert_difference("Team.count", 1) do
      assert team.save
    end

    assert team.uuid.present?
    assert team.public_key.present?
    assert team.secret_key_digest.present?
    assert team.secret_key.present?, "secret_key virtual attribute should be present after save"
  end

  test "authenticates secret_key" do
    team = teams(:one)

    assert team.authenticate_secret_key("secret_test_1")
    refute team.authenticate_secret_key("wrong")
  end

  test "to_param is uuid" do
    assert_equal teams(:one).uuid, teams(:one).to_param
  end
end
