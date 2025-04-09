class AddMissingDeviseColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:users, :encrypted_password)
      add_column :users, :encrypted_password, :string, default: "", null: false
    end
    
    # Make sure other required Devise columns exist
    unless column_exists?(:users, :reset_password_token)
      add_column :users, :reset_password_token, :string
      add_index :users, :reset_password_token, unique: true
    end
    
    unless column_exists?(:users, :reset_password_sent_at)
      add_column :users, :reset_password_sent_at, :datetime
    end
    
    unless column_exists?(:users, :remember_created_at)
      add_column :users, :remember_created_at, :datetime
    end
  end
end
