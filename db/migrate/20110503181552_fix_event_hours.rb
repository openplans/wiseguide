class FixEventHours < ActiveRecord::Migration
  def self.up
    change_column :events, :duration_in_hours, :decimal, :precision=>5, :scale=>2
  end

  def self.down
  end
end
