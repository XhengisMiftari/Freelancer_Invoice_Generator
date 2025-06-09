class DeleteRowFromProjects < ActiveRecord::Migration[7.1]
  def change
    remove_reference :projects, :project_date, foreign_key: true
  end
end
