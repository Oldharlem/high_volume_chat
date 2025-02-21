class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :group
  belongs_to :invited_by, class_name: 'User', foreign_key: 'invited_by_id'

  scope :accepted, -> { where(invitation_accepted: true) }
  scope :pending, -> { where(invitation_accepted: false) }

  validates :user, uniqueness: { scope: :group }

  def self.invite_user(group, user, invited_by)
    create(group: group, user: user, invited_by: invited_by)
  end

  def accept_invitation!
    return if invitation_accepted?

    update!(invitation_accepted: true)
  end
end
