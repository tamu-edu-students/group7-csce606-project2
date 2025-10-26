class AddDeviseToExistingUsers < ActiveRecord::Migration[8.0]
  def change
    change_table :users do |t|
      ## Devise required fields
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      ## Ensure email is non-null and unique
      change_column_default :users, :email, ""
      change_column_null :users, :email, false

      ## Optional but recommended indices
      add_index :users, :email, unique: true
      add_index :users, :reset_password_token, unique: true
    end

    # 🔴 We will no longer use plain `password` column
    remove_column :users, :password, :string
  end
end
