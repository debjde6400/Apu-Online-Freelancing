class MessagesController < ApplicationController
  before_action :find_conversation

  def index
    @conversation.read_unread_messages(current_user.id)
    redirect_to conversations_path(conversation: @conversation)    
  end

  def new
    @message = @conversation.messages.new
  end

  def create
    @message = @conversation.messages.new(message_params)
    if @message.save
      redirect_to conversation_messages_path(@conversation)
    end
  end

  private

  def message_params
    params.require(:message).permit(:body, :siteuser_id)
  end

  def find_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end
end