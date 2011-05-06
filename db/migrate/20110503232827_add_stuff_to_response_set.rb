class AddStuffToResponseSet < ActiveRecord::Migration
  def self.up
    change_table :response_sets do |t|
      t.integer :kase_id
      t.integer :created_by_id
      t.integer :updated_by_id
    end
    drop_table :assessments
  end

  def self.down
    change_table :response_sets do |t|
      t.remove :kase_id
      t.remove :created_by_id
      t.remove :updated_by_id
    end

    create_table "assessments", :force => true do |t|
      t.integer  "kase_id"
      t.integer  "user_id"
      t.integer  "survey_id"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "lock_version",  :default => 0
      t.integer  "created_by_id"
      t.integer  "updated_by_id"
    end
  end
end
