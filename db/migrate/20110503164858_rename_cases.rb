class RenameCases < ActiveRecord::Migration
  def self.up
    rename_table :cases, :kases
    rename_table :case_routes, :kase_routes
    rename_column :assessments, :case_id, :kase_id
    rename_column :contacts, :case_id, :kase_id
    rename_column :events, :case_id, :kase_id
    rename_column :kase_routes, :case_id, :kase_id
    rename_column :outcomes, :case_id, :kase_id
  end

  def self.down
    rename_table :kases, :cases
    rename_table :kase_routes, :case_routes
    rename_column :assessments, :kase_id, :case_id
    rename_column :contacts, :kase_id, :case_id
    rename_column :events, :kase_id, :case_id
    rename_column :kase_routes, :kase_id, :case_id
    rename_column :outcomes, :kase_id, :case_id
  end
end
