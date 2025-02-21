class AddAcceptedIndexToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_index :memberships, :invitation_accepted
  end
end
