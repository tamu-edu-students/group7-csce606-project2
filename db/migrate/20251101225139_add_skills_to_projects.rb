class AddSkillsToProjects < ActiveRecord::Migration[8.0]
  def change
    unless column_exists?(:projects, :skills)
      add_column :projects, :skills, :string
    end
  end
end
