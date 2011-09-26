class ChangeCustomerImpairmentsAddNotes < ActiveRecord::Migration
  def self.up
    add_column :customer_impairments, :notes, :string
  end

  def self.down
    remove_column :customer_impairments, :notes
  end
end
