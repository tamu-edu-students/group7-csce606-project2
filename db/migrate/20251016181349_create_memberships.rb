class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memberable, polymorphic: true, null: false
      t.index [ :memberable_type, :memberable_id ], unique: true
      t.timestamps
    end
  end
end
