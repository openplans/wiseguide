class FixOutcomes < ActiveRecord::Migration
  def self.up
    change_table :outcomes do |t|
      t.rename :three_vehicle_miles_reduced, :three_month_vehicle_miles_reduced
      t.integer  :six_month_trip_count
      t.integer  :six_month_vehicle_miles_reduced
      t.boolean  :six_month_unreachable
      t.remove  :three_month_unreachable
      t.boolean  :three_month_unreachable
    end
  end

  def self.down
    change_table :outcomes do |t|
      t.rename :three_month_vehicle_miles_reduced, :three_vehicle_miles_reduced
      t.remove  :six_month_trip_count
      t.remove  :six_month_vehicle_miles_reduced
      t.remove  :six_month_unreachable
      t.change  :three_month_unreachable, :integer
    end
  end
end
