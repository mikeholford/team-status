class StatusUpdate < ApplicationRecord
  belongs_to :team_user
  belongs_to :team

  validates :status, presence: true
  validate :team_matches_user
  validate :expires_at_in_future

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  private

  def expires_at_in_future
    return if expires_at.blank?

    errors.add(:expires_at, "must be in the future") if expires_at <= Time.current
  end

  def team_matches_user
    return if team_user.blank? || team.blank?
    return if team_user.team_id == team_id

    errors.add(:team_id, "must match team_user.team_id")
  end
end
