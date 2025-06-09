class InsertRow < ActiveRecord::Migration[7.1]
  def change
    add_reference :project_dates, :project, null: false, foreign_key: true
  end
end
