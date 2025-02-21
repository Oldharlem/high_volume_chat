class User < ApplicationRecord
  has_many :invitations, -> { Membership.pending }, class_name: 'Membership', foreign_key: 'user_id'
  has_many :memberships, -> { Membership.accepted }, class_name: 'Membership', foreign_key: 'user_id'

  has_many :groups, through: :memberships
  has_many :messages, dependent: :destroy

  validates :name, presence: true
end
