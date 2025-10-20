class CreateBulletinPosts < ActiveRecord::Migration[8.0]
  def change
    create_table :bulletin_posts do |t|
      t.string :title
      t.text :description
      t.boolean :active, default: true
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
