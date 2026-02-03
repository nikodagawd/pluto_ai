class ChatController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @companies = []
    @is_recommendation = false
    @lists = user_signed_in? ? current_user.lists.order(created_at: :desc) : []
  end

  def create
    @message = params[:message]
    search_result = search_companies(@message)
    @companies = search_result[:companies]
    @is_recommendation = search_result[:is_recommendation]
    @lists = current_user.lists.order(created_at: :desc)
    render :index, formats: [:html]
  end

  private

  def search_companies(message)
    chat = RubyLLM.chat(model: "gpt-4o-mini")

    response = chat.ask(<<~PROMPT)
      Analyze: "#{message}"
      Available sectors: Technology, Healthcare, Finance, Manufacturing, Retail, Energy, Real Estate, Transportation, Media, Food & Beverage.

      Return ONLY JSON:
      {
        "sector": "Choose the closest from the list above",
        "city": "City name or null",
        "main_keyword": "ONE single word that defines the core business (e.g., 'spice', 'software', 'solar')"
      }
    PROMPT

    begin
      parsed = JSON.parse(response.content.gsub(/```json|```/, "").strip)


      results = Company.all
      results = results.where("city ILIKE ?", "%#{parsed['city']}%") if parsed['city'].present?

      if parsed['sector'].present? || parsed['main_keyword'].present?
        results = results.where(
          "sector ILIKE ? OR sub_sector ILIKE ? OR description ILIKE ? OR company_name ILIKE ?",
          "%#{parsed['sector']}%",
          "%#{parsed['sector']}%",
          "%#{parsed['main_keyword']}%",
          "%#{parsed['main_keyword']}%"
        )
      end

      final_companies = results.limit(10)


      if final_companies.empty? && parsed['sector'].present?
        final_companies = Company.where("sector ILIKE ?", "%#{parsed['sector']&.split(' ')&.first}%").limit(5)
        is_rec = true
      else
        is_rec = false
      end

      { companies: final_companies, is_recommendation: is_rec }
    rescue
      { companies: [], is_recommendation: false }
    end
  end
end
