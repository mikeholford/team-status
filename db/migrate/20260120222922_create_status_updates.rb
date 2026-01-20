class CreateStatusUpdates < ActiveRecord::Migration[8.1]
  def change
    create_table :status_updates do |t|
      t.references :team_user, null: false, foreign_key: true
      t.references :team, null: false
      t.text :status, null: false

      t.timestamps
    end

    add_index :status_updates, [:team_user_id, :created_at]
  end
end
