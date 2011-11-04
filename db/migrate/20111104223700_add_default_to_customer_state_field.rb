class AddDefaultToCustomerStateField < ActiveRecord::Migration
  def self.up
    change_column_default :customers, :state, "OR"
  end

  def self.down
  end
end
