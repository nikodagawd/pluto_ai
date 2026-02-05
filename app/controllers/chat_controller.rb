class ChatController < ApplicationController
  def index
    @companies = []
    @is_recommendation = false
    @lists = user_signed_in? ? current_user.lists.order(created_at: :desc) : []
  end

  def create
    unless user_signed_in?
      redirect_to new_user_session_path, alert: "Please sign in to send a message"
      return
    end

    @message = params[:message]
    search_result = search_companies(@message)
    @companies = search_result[:companies]
    @is_recommendation = search_result[:is_recommendation]
    @lists = current_user.lists.order(created_at: :desc)
    render :index, formats: [:html]
  end

  private

  def available_sectors
    Rails.cache.fetch("company_sectors", expires_in: 1.hour) do
      Company.distinct.pluck(:sector).compact.sort
    end
  end

  def sanitize_for_like(value)
    value.to_s.gsub(/[%_]/, "")
  end

  def search_companies(message)
    sectors_list = available_sectors.join(", ")
    escaped_message = message.gsub('"', '\"')

    chat = RubyLLM.chat(model: "gpt-4o-mini")

    response = chat.ask(<<~PROMPT)
      You are a search query extractor for a company database. Analyze the user's message and extract structured filters.

      User message: "#{escaped_message}"
      Available sectors: #{sectors_list}

      Return ONLY valid JSON (no markdown, no code fences):
      {
        "sector": "closest sector from the list above, or null",
        "city": "city name if mentioned, or null",
        "keywords": ["keyword1", "keyword2"]
      }

      Keyword rules:
      - Extract 1-3 words that describe the INDUSTRY or PRODUCT the user is looking for
      - Use words that would appear in a company name, sector, or business description
      - DO NOT include intent words like "supplier", "provider", "company", "find", "need", "buy", "sell", "machine"
      - Good examples: "coffee" from "coffee machine suppliers", "solar" from "solar panel installers", "fintech" from "fintech startups"
      - Bad examples: "supplier", "installer", "provider", "startup", "machine"
    PROMPT

    begin
      parsed = JSON.parse(response.content.gsub(/```json|```/, "").strip)
    rescue JSON::ParserError => e
      Rails.logger.error("[ChatController] LLM returned invalid JSON: #{e.message}")
      return { companies: [], is_recommendation: false }
    end

    sector   = parsed["sector"].presence
    city     = parsed["city"].presence
    keywords = Array(parsed["keywords"]).select(&:present?)

    # When keywords are available, rely on full-text search for relevance
    # (sector is already embedded in the search vector with weight B).
    # The explicit sector ILIKE filter is only used as a last-resort fallback
    # for vague queries, since the LLM often picks a sector that's too narrow.

    # --- Primary: city + keywords (full-text handles sector matching) ---
    if keywords.any?
      results = Company.search_by_text(keywords)
      results = results.where("city ILIKE ?", "%#{sanitize_for_like(city)}%") if city
      final = results.limit(50).to_a

      # --- Fallback 1: drop city, keywords only ---
      if final.empty? && city
        final = Company.search_by_text(keywords).limit(50).to_a
      end

      # --- Fallback 2: trigram similarity on company name (catches typos) ---
      if final.empty?
        final = Company.search_by_name_similarity(keywords.first).limit(50).to_a
      end
    end

    # --- Fallback 3: sector + city (for queries with no useful keywords) ---
    if final.nil? || final.empty?
      if sector
        results = Company.where("sector ILIKE ?", "%#{sanitize_for_like(sector)}%")
        results = results.where("city ILIKE ?", "%#{sanitize_for_like(city)}%") if city
        final = results.order(employees: :desc).limit(50).to_a

        # Drop city if no results
        if final.empty? && city
          final = Company.where("sector ILIKE ?", "%#{sanitize_for_like(sector)}%")
                          .order(employees: :desc)
                          .limit(50)
                          .to_a
        end
        is_recommendation = true
      end
    end

    { companies: final, is_recommendation: is_recommendation || false }
  rescue StandardError => e
    Rails.logger.error("[ChatController] search_companies error: #{e.message}")
    { companies: [], is_recommendation: false }
  end
end
