class AddTeamForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :team_users, :teams
    add_foreign_key :status_updates, :teams
  end
end
