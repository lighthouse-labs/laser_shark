class AlterAssistanceRequestsReason < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        change_column :assistance_requests, :reason, :text
      end
      dir.down do
        change_column :assistance_requests, :reason, :string
      end
    end
  end
end
