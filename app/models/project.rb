class Project < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :invoices, dependent: :destroy
  has_one :project_date, dependent: :destroy
end
