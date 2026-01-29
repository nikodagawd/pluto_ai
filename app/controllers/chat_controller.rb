class ChatController < ApplicationController

  def index

    @companies = []

    @is_recommendation = false

  end



  def create

    @message = params[:message]

    search_result = search_companies(@message)

    @companies = search_result[:companies]

    @is_recommendation = search_result[:is_recommendation]

    render :index, formats: [:html]

  end



  private



  def search_companies(message)

    chat = RubyLLM.chat(model: "gpt-4o-mini")

    sample_data = Company.limit(100).map { |c| "#{c.company_name}: #{c.sector} in #{c.city}. Description: #{c.description}" }.join("\n")



    response = chat.ask(<<~PROMPT)

      You are a company discovery assistant.

      User Query: "#{message}"



      Database Context:

      #{sample_data}



      Instructions:

      1. Find companies that match the criteria EXACTLY (e.g., same city and sector).

      2. If few or no exact matches exist, find the most relevant alternatives.



      Return ONLY a JSON object with this format:

      {

        "is_recommendation": true/false (true if you didn't find exact matches),

        "names": ["Company Name 1", "Company Name 2"]

      }

    PROMPT



    parsed = JSON.parse(response.content.gsub(/```json|```/, "").strip) rescue { "names" => [], "is_recommendation" => false }



    {

      companies: Company.where(company_name: parsed["names"]).limit(10),

      is_recommendation: parsed["is_recommendation"]

    }

  end

end
