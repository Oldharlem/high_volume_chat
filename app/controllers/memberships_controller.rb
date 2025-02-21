class MembershipsController < ApplicationController
  def index
    @invitations = current_user.invitations.includes(:group, :invited_by)
  end

  def accept
    membership = current_user.invitations.find(params[:id])
    membership.accept_invitation!
    
    redirect_to group_path(membership.group), notice: "You've joined #{membership.group.name}!"
  end

  def destroy
    membership = current_user.invitations.find(params[:id])
    membership.destroy
    
    redirect_to memberships_path, notice: "Invitation declined"
  end
end 