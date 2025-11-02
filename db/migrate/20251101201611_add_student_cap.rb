class AddStudentCap < ActiveRecord::Migration[8.0]
  def change
    add_column :teaching_offers, :student_cap, :integer, default: 1, null: false
  end
end
