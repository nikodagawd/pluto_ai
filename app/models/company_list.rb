class CompanyList < ApplicationRecord
  # Associations
  belongs_to :company
  belongs_to :list

  # Validations
  validates :company_id, uniqueness: { scope: :list_id }
end
