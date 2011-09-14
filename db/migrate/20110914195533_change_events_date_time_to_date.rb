class ChangeEventsDateTimeToDate < ActiveRecord::Migration
  def self.up
    rename_column :events, :date_time, :date
    change_column :events, :date, :date
  end

  def self.down
    change_column :events, :date, :datetime
    rename_column :events, :date, :date_time
  end
end
