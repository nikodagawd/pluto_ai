class Company < ApplicationRecord
  has_many :company_lists, dependent: :destroy
  has_many :lists, through: :company_lists

  scope :search_by_text, ->(*keywords) {
    # Build an OR-based tsquery so matching ANY keyword is enough,
    # while ts_rank_cd ranks companies matching more keywords higher.
    keywords = keywords.flatten.select(&:present?)
    return none if keywords.empty?

    or_parts = keywords.map { |kw| "plainto_tsquery('english', #{connection.quote(kw)})" }
    tsquery_sql = or_parts.join(" || ")

    where("search_vector @@ (#{tsquery_sql})")
      .order(Arel.sql("ts_rank_cd(search_vector, (#{tsquery_sql})) DESC"))
  }

  scope :search_by_name_similarity, ->(name) {
    where("similarity(company_name, ?) > 0.2", name)
      .order(Arel.sql("similarity(company_name, #{connection.quote(name)}) DESC"))
  }

  def self.recommend(filters)
    scope = all

    if filters.present?
      if filters["keywords"].present?
        filters["keywords"].each do |kw|
          scope = scope.where(
            "company_name ILIKE :kw OR description ILIKE :kw OR sector ILIKE :kw OR sub_sector ILIKE :kw",
            kw: "%#{kw}%"
          )
        end
      end

      scope = scope.where("sector ILIKE ?", "%#{filters['sector']}%") if filters["sector"].present?
      scope = scope.where("sub_sector ILIKE ?", "%#{filters['sub_sector']}%") if filters["sub_sector"].present?
      scope = scope.where("city ILIKE ?", "%#{filters['city']}%") if filters["city"].present?
      scope = scope.where("country ILIKE ?", "%#{filters['country']}%") if filters["country"].present?
      scope = scope.where("funding_stage ILIKE ?", "%#{filters['funding_stage']}%") if filters["funding_stage"].present?
    end

    scope
  end
end
