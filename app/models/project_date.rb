class ProjectDate < ApplicationRecord
  belongs_to :project

  def start_time
    start_date
  end

  def end_time
    end_date
  end

end
