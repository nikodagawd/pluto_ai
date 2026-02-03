class CompanyList < ApplicationRecord
  belongs_to :company
  belongs_to :list

  validates :company_id, uniqueness: { scope: :list_id }
end
