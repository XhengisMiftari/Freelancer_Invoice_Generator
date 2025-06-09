class Deleterow < ActiveRecord::Migration[7.1]
  def change
    remove_reference :projects, :project, foreign_key: true
  end
end
