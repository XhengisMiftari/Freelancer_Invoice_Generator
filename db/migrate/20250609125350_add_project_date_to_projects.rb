class AddProjectDateToProjects < ActiveRecord::Migration[7.1]
  def change
    add_reference :projects, :project_date, null: false, foreign_key: true
  end
end
