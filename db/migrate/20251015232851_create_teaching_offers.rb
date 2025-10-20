class CreateTeachingOffers < ActiveRecord::Migration[8.0]
  def change
    create_table :teaching_offers do |t|
      t.string :title
      t.text :description
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
