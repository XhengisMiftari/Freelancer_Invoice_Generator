class Client < ApplicationRecord
  has_many :projects
  has_many :invoices, through: :projects
  has_many :project_dates, through: :projects
end
