class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.integer :role_cnt
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
