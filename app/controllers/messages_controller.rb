class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat

  def create
    @message = @chat.messages.build(message_params)

    respond_to do |format|
      if @message.save
        format.html { redirect_to @chat }
        format.json { render json: @message, status: :created }
      else
        format.html { redirect_to @chat, alert: "Could not send message." }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:role, :content)
  end
end
