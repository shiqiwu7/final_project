# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
  def self.up
    change_table :users do |t|
      # 以下字段已存在，注释掉
      # t.string :email,              null: false, default: ""
      # t.string :encrypted_password, null: false, default: ""

      ## Recoverable（你可以先确认这两个字段是否存在）
      # t.string   :reset_password_token
      # t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at unless column_exists?(:users, :remember_created_at)

      ## Trackable（如果要使用，再打开）
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # t.timestamps null: false  # 你已经有 created_at 和 updated_at，无需再加
    end

    # 下面这些索引也可能已经存在，根据报错提示决定是否注释
    # add_index :users, :email, unique: true
    # add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token, unique: true
    # add_index :users, :unlock_token, unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
