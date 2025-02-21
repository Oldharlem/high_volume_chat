class Group < ApplicationRecord
  has_many :memberships, -> { Membership.accepted }, dependent: :destroy
  has_many :users, through: :memberships

  has_many :messages, dependent: :destroy, inverse_of: :group

  validates :name, presence: true, uniqueness: true
end
