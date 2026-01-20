class TeamUser < ApplicationRecord
  belongs_to :team
  has_many :status_updates, dependent: :destroy

  validates :username, presence: true, uniqueness: { scope: :team_id }

  def current_status
    current_status_update&.status
  end

  def current_status_update
    status_updates.order(created_at: :desc).first
  end
end
