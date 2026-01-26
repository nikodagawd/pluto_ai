class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @chat = current_user.chats.find(params[:id])
    @messages = @chat.messages.order(created_at: :asc)

    respond_to do |format|
      format.html
      format.json { render json: { chat: @chat, messages: @messages } }
    end
  end

  def create
    @chat = current_user.chats.build(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to @chat }
        format.json { render json: @chat, status: :created }
      else
        format.html { redirect_to root_path, alert: "Could not create chat." }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:status, messages_attributes: [:role, :content])
  end
end
