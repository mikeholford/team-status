class AddTeamForeignKeys < ActiveRecord::Migration[8.1]
  def change
    add_foreign_key :team_users, :teams, if_not_exists: true
    add_foreign_key :status_updates, :teams, if_not_exists: true
  end
end
