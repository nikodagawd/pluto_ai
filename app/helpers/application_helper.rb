module ApplicationHelper
  # Known inferred midpoints from Companies House accounts categories
  INFERRED_MIDPOINTS = {
    316_000 => "<1M",          # Micro Entity: 0-632k
    5_100_000 => "1-10M",      # Total Exemption Full / Small: 0-10.2M
    18_000_000 => "<36M",      # Audit Exemption Subsidiary: 0-36M
    505_100_000 => ">500M",    # Full / Group: 10.2M-1B
  }.freeze

  def display_revenue(revenue)
    return "£<1M" if revenue.nil? || revenue.zero?

    rounded = revenue.to_i
    if INFERRED_MIDPOINTS.key?(rounded)
      "£#{INFERRED_MIDPOINTS[rounded]}"
    elsif rounded < 1_000_000
      "£#{number_to_human(rounded, units: { thousand: 'K' }, precision: 0)}"
    else
      "£#{number_to_human(rounded, units: { million: 'M' }, precision: 1)}"
    end
  end
end
