class ReplaceActiveWithStatus < ActiveRecord::Migration[8.0]
  def change
    remove_column :teaching_offers, :active, :boolean
    add_column :teaching_offers, :status, :string, default: "pending", null: false
  end
end
