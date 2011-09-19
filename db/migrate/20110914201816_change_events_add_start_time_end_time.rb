class ChangeEventsAddStartTimeEndTime < ActiveRecord::Migration
  def self.up
    add_column :events, :start_time, :time
    add_column :events, :end_time, :time
  end

  def self.down
    remove_column :events, :start_time
    remove_column :events, :end_time
  end
end
