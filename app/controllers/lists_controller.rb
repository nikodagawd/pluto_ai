class ListsController < ApplicationController
  before_action :authenticate_user!

  def index
    @lists = current_user.lists

    respond_to do |format|
      format.html
      format.json { render json: @lists }
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
    @list = current_user.lists.build(list_params)

    respond_to do |format|
      if @list.save
        format.html { redirect_to @list, notice: "List created successfully." }
        format.json { render json: @list, status: :created }
      else
        format.html { redirect_to lists_path, alert: "Could not create list." }
        format.json { render json: @list.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
