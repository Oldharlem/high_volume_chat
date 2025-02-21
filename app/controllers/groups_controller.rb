class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
    
    if @groups.any?
      redirect_to group_path(@groups.first)
    else
      redirect_to new_group_path
    end
  end

  def show
    @groups = current_user.groups
    @group = @groups.find(params[:id])
    @messages = @group.messages
      .includes(:user)
      .order(created_at: :desc)
      .limit(20)
      .reverse
  end

  def create
    @group = Group.new(group_params)
    
    if @group.save
      # Create initial membership for group creator
      Membership.create!(
        group: @group,
        user: current_user,
        invited_by: current_user,
        invitation_accepted: true
      )
      
      redirect_to group_path(@group), notice: "Group '#{@group.name}' created successfully!"
    else
      redirect_to groups_path, alert: @group.errors.full_messages.to_sentence
    end
  end

  def new
    @group = Group.new
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end 