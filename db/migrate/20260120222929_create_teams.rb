class CreateTeams < ActiveRecord::Migration[8.1]
  def change
    create_table :teams do |t|
      t.string :uuid, null: false
      t.string :name, null: false
      t.string :public_key, null: false
      t.string :secret_key_digest, null: false

      t.timestamps
    end

    add_index :teams, :uuid, unique: true
    add_index :teams, :public_key, unique: true
  end
end
