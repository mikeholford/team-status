class CreateTeamUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :team_users do |t|
      t.references :team, null: false
      t.string :username, null: false
      t.string :profile_pic_url

      t.timestamps
    end

    add_index :team_users, [:team_id, :username], unique: true
  end
end
