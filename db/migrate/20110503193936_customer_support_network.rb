class CustomerSupportNetwork < ActiveRecord::Migration
  def self.up
    create_table :customer_support_network_members do |t|
      t.integer :customer_id
      t.string :name
      t.string :title
      t.string :organization
      t.string :phone_number
      t.string :email
      t.datetime :created_at
      t.integer :created_by_id
      t.datetime :updated_at
      t.integer :updated_by_id
      t.integer :lock_version, :default=>0
    end
  end

  def self.down
  end
end
