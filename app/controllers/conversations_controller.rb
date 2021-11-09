class ConversationsController < ApplicationController
  before_action :logged_in?

  def index
    @freelancers = Siteuser.freelancers
    @conversations = Conversation.involving(current_user.id).includes([:messages])
    
    if params[:conversation]
      @conversation = Conversation.find(params[:conversation])
      @messages = @conversation.messages

      if @messages.length > 10
        @over_ten = true
        @messages = @messages[-10..-1]
      end

      if params[:m]
        @over_ten = false
        @messages = @conversation.messages
      end

      @message = @conversation.messages.new
    end
  end

  def create
    if Conversation.between(params[:sender_id], params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id], params[:recipient_id])
    else
      @conversation = Conversation.create!(conversation_params)
    end
    
    redirect_to conversation_messages_path(@conversation)
  end

  private

  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end
end