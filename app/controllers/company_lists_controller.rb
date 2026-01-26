class CompanyListsController < ApplicationController
  before_action :authenticate_user!

  def create
    @list = current_user.lists.find(params[:list_id])
    @company_list = @list.company_lists.build(company_list_params)

    respond_to do |format|
      if @company_list.save
        format.html { redirect_to @list, notice: "Company added to list." }
        format.json { render json: @company_list, status: :created }
      else
        format.html { redirect_to @list, alert: "Could not add company to list." }
        format.json { render json: @company_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @list = current_user.lists.find(params[:list_id])
    @company_list = @list.company_lists.find(params[:id])
    @company_list.destroy

    respond_to do |format|
      format.html { redirect_to @list, notice: "Company removed from list." }
      format.json { head :no_content }
    end
  end

  private

  def company_list_params
    params.require(:company_list).permit(:company_id)
  end
end
