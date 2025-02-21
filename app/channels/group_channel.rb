class GroupChannel < ApplicationCable::Channel
  def subscribed
    @group = Group.find(params[:group_id])
    
    if authorized?
      stream_from "group_#{@group.id}"
    else
      reject
    end
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def authorized?
    @group.memberships.accepted.exists?(user: current_user)
  end
end 