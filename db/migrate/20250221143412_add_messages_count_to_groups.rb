class AddMessagesCountToGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :groups, :messages_count, :integer, default: 0, null: false

    # Backfill existing counts
    reversible do |dir|
      dir.up do
        Group.find_each do |group|
          Group.reset_counters(group.id, :messages)
        end
      end
    end
  end
end 