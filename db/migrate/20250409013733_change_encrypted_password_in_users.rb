class ChangeEncryptedPasswordInUsers < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :encrypted_password, :string, null: true
  end
end
