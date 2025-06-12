class Client < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :invoices, through: :projects
  has_many :project_dates, through: :projects
  belongs_to :user

  validates :first_name, :last_name, :email, :phone_number, :date_of_birth, presence: true
  validates :email,
    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email" },
    uniqueness: { case_sensitive: false }
  validates :company_name, length: { maximum: 100 }, allow_blank: true
end
