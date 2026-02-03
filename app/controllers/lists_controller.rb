class ListsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_list, only: [:show, :destroy]

  def index
    @list  = current_user.lists.new
    @lists = current_user.lists
                         .order(created_at: :desc)
                         .includes(company_lists: :company)

    respond_to do |format|
      format.html
      format.json { render json: @lists }
    end
  end

  def show
    @companies = @list.companies

    respond_to do |format|
      format.html
      format.json { render json: { list: @list, companies: @companies } }
    end
  end

  def create
    if params[:list].present? && params[:list][:name].present?
      @list = current_user.lists.new(list_params)

      if @list.save
        redirect_to lists_path, notice: "List created ✅"
      else
        @lists = current_user.lists
                             .order(created_at: :desc)
                             .includes(company_lists: :company)
        flash.now[:alert] = @list.errors.full_messages.to_sentence
        render :index, status: :unprocessable_entity
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
        format.html { redirect_back fallback_location: root_path, notice: "Added ✅" }
        format.json { render json: { list: list, company: company }, status: :created }
      end

      return
    end

    redirect_to lists_path, alert: "Nothing added."
  end

  def destroy
    @list.destroy
    redirect_to lists_path, notice: "List deleted."
  end

  private

  def set_list
    @list = current_user.lists.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end
end
