class Company < ApplicationRecord
  # Associations
  has_many :company_lists, dependent: :destroy
  has_many :lists, through: :company_lists

  # Validations
  validates :company_name, presence: true
end
