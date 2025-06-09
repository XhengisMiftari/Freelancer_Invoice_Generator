class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_one :project_date
end
