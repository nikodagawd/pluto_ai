class Company < ApplicationRecord
  has_many :company_lists, dependent: :destroy
  has_many :lists, through: :company_lists

  def self.recommend(filters)
    scope = all

    if filters.present?
      if filters["keywords"].present?
        filters["keywords"].each do |kw|
          scope = scope.where(
            "name ILIKE :kw OR description ILIKE :kw OR sector ILIKE :kw OR subsector ILIKE :kw",
            kw: "%#{kw}%"
          )
        end
      end

      scope = scope.where("sector ILIKE ?", "%#{filters['sector']}%") if filters["sector"].present?
      scope = scope.where("subsector ILIKE ?", "%#{filters['subsector']}%") if filters["subsector"].present?
      scope = scope.where("city ILIKE ?", "%#{filters['city']}%") if filters["city"].present?
      scope = scope.where("country ILIKE ?", "%#{filters['country']}%") if filters["country"].present?
      scope = scope.where("funding_stage ILIKE ?", "%#{filters['funding_stage']}%") if filters["funding_stage"].present?
    end

    scope
  end
end
