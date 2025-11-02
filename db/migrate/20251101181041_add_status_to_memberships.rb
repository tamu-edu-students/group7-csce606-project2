class AddStatusToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :status, :string, default: "pending"
  end
end
