class FixMembershipsUniqueIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :memberships, name: "index_memberships_on_memberable_type_and_memberable_id", if_exists: true
    remove_index :memberships, name: "index_memberships_on_memberable", if_exists: true

    # Shorter name, same logic
    add_index :memberships, [:memberable_type, :memberable_id, :user_id],
              unique: true,
              name: "idx_memberships_memberable_user"
  end
end
