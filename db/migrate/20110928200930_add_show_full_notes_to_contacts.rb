class AddShowFullNotesToContacts < ActiveRecord::Migration
  def self.up
    add_column :contacts, :show_full_notes, :boolean
  end

  def self.down
    remove_column :contacts, :show_full_notes
  end
end
