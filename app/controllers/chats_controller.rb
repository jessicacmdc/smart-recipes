class ChatsController < ApplicationController
  before_action :set_chat, only: %i[show destroy]
  def index
    @chats = Chat.all
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = Chat.new(title: "Untitled", model_id: "gpt-4.1-nano")
    @chat.user = current_user
    if @chat.save
      redirect_to chat_path(@chat)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @message = Message.new
  end

  def destroy
    @chat.destroy
    redirect_to chats_path, status: :see_other
  end

  private

  # def chat_params
  #   params.require(:chat).permit(:title)
  # end

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
