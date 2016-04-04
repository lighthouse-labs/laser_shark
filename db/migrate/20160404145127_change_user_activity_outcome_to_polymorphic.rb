class ChangeUserActivityOutcomeToPolymorphic < ActiveRecord::Migration
  def change
    file_path = File.join(Rails.root, "app", "models", "user_activity_outcome.rb")
    if File.exists?(file_path)
      UserActivityOutcome.destroy_all
      drop_table :user_activity_outcomes

      File.delete(file_path)
    end
  end
end
