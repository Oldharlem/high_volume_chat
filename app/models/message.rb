class Message < ApplicationRecord
  belongs_to :group, inverse_of: :messages, counter_cache: true
  belongs_to :user, inverse_of: :messages

  validates :body, presence: true
  validate :user_belongs_to_group

  after_commit on: :create do
    broadcast_to_group
  end

  private

  def broadcast_to_group
    ActionCable.server.broadcast(
      "group_#{group_id}",
      {
        success: true,
        message: self.as_json(
          only: [:id, :body, :created_at],
          include: { user: { only: [:id, :name] } }
        )
      }
    )
  end

  def user_belongs_to_group
    unless user.groups.include?(group)
      errors.add(:base, "User is not a member of this group")
    end
  end
end
