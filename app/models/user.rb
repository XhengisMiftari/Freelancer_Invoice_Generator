class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_one_attached :avatar
  has_many :projects
  has_many :clients, through: :projects
  has_many :invoices, through: :projects
  has_many :project_dates, through: :projects

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
