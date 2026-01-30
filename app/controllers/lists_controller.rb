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
    if params[:list].present? && params[:list][:name].present?
      @list = current_user.lists.new(list_params)

      respond_to do |format|
        if @list.save
          format.html { redirect_to lists_path, notice: "List created ✅" }
          format.json { render json: { list: @list }, status: :created }
        else
          format.html { redirect_to lists_path, alert: @list.errors.full_messages.to_sentence.presence || "Could not create list." }
          format.json { render json: { errors: @list.errors.full_messages }, status: :unprocessable_entity }
        end
      end

      return
    end

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

      list.companies << company unless list.companies.exists?(company.id)

      respond_to do |format|
        format.html { redirect_back fallback_location: root_path, notice: "Added to My Favorites ✅" }
        format.json { render json: { list: list, company: company }, status: :created }
      end

      return
    end

    redirect_to lists_path, alert: "Nothing added."
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
