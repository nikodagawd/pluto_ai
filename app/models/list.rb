class List < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :company_lists, dependent: :destroy
  has_many :companies, through: :company_lists

  # Validations
  validates :name, presence: true
end
