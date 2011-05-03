class MakeUserStampable < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :updated_by
      t.string :created_by
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :updated_by
      t.remove :created_by
    end
  end
end
