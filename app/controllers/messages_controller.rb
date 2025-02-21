class MessagesController < ApplicationController

  before_action :set_group

  def index
    @messages = @group.messages
      .includes(:user)
      .order(created_at: :desc)
      .limit(20)
      .offset(params[:offset])
      .reverse

    render json: {
      messages: @messages.map { |message|
        message.as_json(
          only: [:id, :body, :created_at],
          include: { user: { only: [:id, :name] } }
        )
      }
    }
  end

  def create
    @message = current_user.messages.build(message_params.merge(group_id: params[:group_id]))

    if @message.save
      render json: {
        success: true,
        message: @message.as_json(
          only: [:id, :body, :created_at],
          include: { user: { only: [:id, :name] } }
        )
      }
    else
      render json: { 
        success: false, 
        errors: @message.errors.full_messages 
      }, 
      status: :unprocessable_entity
    end
  end

  private

  def set_group
    @group = current_user.groups.find(params[:group_id])
  end

  def message_params
    params.require(:message).permit(:body)
  end
end 