class RenameStatus < ActiveRecord::Migration[8.0]
  def change
    remove_column :teaching_offers, :status, :string, default: "pending", null: false
    add_column :teaching_offers, :offer_status, :string, default: "pending", null: false
  end
end
