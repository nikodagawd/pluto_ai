class CompanyListsController < ApplicationController
  before_action :authenticate_user!

  def create
    @list = current_user.lists.find(params[:list_id])
    @company_list = @list.company_lists.build(company_list_params)

    respond_to do |format|
      if @company_list.save
        format.turbo_stream { render :create }
        format.html { redirect_back fallback_location: lists_path, notice: "Company added ✅" }
        format.json { render json: @company_list, status: :created }
      else
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_back fallback_location: lists_path, alert: "Could not add company." }
        format.json { render json: @company_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
     @company_list = CompanyList
      .joins(:list)
      .where(lists: { user_id: current_user.id })
      .find(params[:id])

    @company_list.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: lists_path, notice: "Company removed from list ✅" }
      format.json { head :no_content }
    end
  end

  private

  def company_list_params
    if params[:company_list].present?
      params.require(:company_list).permit(:company_id)
    else
      params.permit(:company_id)
    end
  end
end
