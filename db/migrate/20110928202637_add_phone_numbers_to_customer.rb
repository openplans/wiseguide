class AddPhoneNumbersToCustomer < ActiveRecord::Migration
  def self.up
    change_table :customers do |t|
      t.string :phone_number_3
      t.string :phone_number_4
    end
  end

  def self.down
    change_table :customers do |t|
      t.remove :phone_number_3
      t.remove :phone_number_4
    end
  end
end
