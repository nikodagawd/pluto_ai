class List < ApplicationRecord
  belongs_to :user
  has_many :company_lists, dependent: :destroy
  has_many :companies, through: :company_lists

  validates :name, presence: true
end
