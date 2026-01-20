class StatusUpdate < ApplicationRecord
  belongs_to :team_user
  belongs_to :team

  validates :status, presence: true
  validate :team_matches_user

  private

  def team_matches_user
    return if team_user.blank? || team.blank?
    return if team_user.team_id == team_id

    errors.add(:team_id, "must match team_user.team_id")
  end
end
