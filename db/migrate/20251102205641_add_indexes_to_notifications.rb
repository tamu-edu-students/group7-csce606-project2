class AddIndexesToNotifications < ActiveRecord::Migration[8.0]
  def change
    add_index :notifications, [ :user_id, :read ]
  end
end
