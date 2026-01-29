class ListsController < ApplicationController
  before_action :authenticate_user!

  def index
    list = current_user.lists.find_or_create_by!(name: "My List")
    @companies = list.companies

    respond_to do |format|
      format.html
      format.json { render json: @companies }
    end
  end

  def show
    @list = current_user.lists.find(params[:id])
    @companies = @list.companies

    respond_to do |format|
      format.html
      format.json { render json: { list: @list, companies: @companies } }
    end
  end

  def create
    # Plus-button adds a company to "My List"
    if params[:company_name].present?
      list = current_user.lists.find_or_create_by!(name: "My List")

      company = Company.find_or_create_by!(
        company_name: params[:company_name],
        city: params[:city]
      ) do |c|
        c.sector = params[:sector]
        c.description = params[:description]
        c.employees = params[:employees]
        c.founded_year = params[:founded_year]
      end

      # Avoid duplicates in the list
      list.companies << company unless list.companies.exists?(company.id)

      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Added to My Favorites ✅" }
        format.json { render json: { list: list, company: company }, status: :created }
      end

      return
    end

    # If someone hits POST /lists without company data
    redirect_to lists_path, alert: "Nothing to add."
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
