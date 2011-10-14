class AddCountyToCustomersAndCase < ActiveRecord::Migration
  def self.up
    change_table :customers do |t|
      t.string :county, :limit => 25
    end
    change_table :kases do |t|
      t.string :county, :limit => 1
    end
  end

  def self.down
    change_table :customers do |t|
      t.remove :county
    end
    change_table :kases do |t|
      t.remove :county
    end
  end
end
