class AddExpiresAtToStatusUpdates < ActiveRecord::Migration[8.1]
  def change
    add_column :status_updates, :expires_at, :datetime
    add_index :status_updates, :expires_at
  end
end
