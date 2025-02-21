class InvitationsController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    user = User.find(params[:user_id])

    if Membership.exists?(user: user, group: @group)
      redirect_to group_path(@group), alert: "User is already a member or has a pending invitation"
    else
      Membership.invite_user(@group, user, current_user)
      redirect_to group_path(@group), notice: "Invitation sent to #{user.name}"
    end
  end
end

