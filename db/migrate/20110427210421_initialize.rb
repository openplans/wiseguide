class Initialize < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :default => "", :null => false
      t.string :encrypted_password, :limit => 128, :default => "", :null => false
      t.string :password_salt, :default => "", :null => false
      t.string :reset_password_token
      t.string :remember_token
      t.datetime :remember_created_at
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer  :level

      t.datetime :created_at
      t.datetime :updated_at
    end

    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.date :birth_date
      t.string :gender
      t.string :phone_number_1
      t.string :phone_number_2
      t.string :email, :unique=>true
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.integer :ethnicity_id
      t.text :notes
      t.string :portrait_file_name
      t.string :portrait_content_type
      t.integer :portrait_file_size
      t.datetime :portrait_updated_at

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :customer_impairments do |t|
      t.integer :customer_id
      t.integer :impairment_id

      t.datetime :created_at
      t.string :created_by
    end

    create_table :impairments do |t|
      t.string :name

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :cases do |t|
      t.integer :customer_id
      t.date :open_date
      t.date :close_date
      t.string :referral_source
      t.integer :referral_type_id
      t.integer :user_id
      t.integer :funding_source_id
      t.integer :disposition_id

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :case_routes do |t|
      t.integer :case_id
      t.integer :route_id

      t.datetime :created_at
      t.string :created_by
    end

    create_table :routes do |t|
      t.string :name, :unique => true

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :referral_types do |t|
      t.string :name, :unique => true

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :outcomes do |t|
      t.integer :case_id
      t.integer :trip_reason_id
      t.integer :exit_trip_count
      t.integer :exit_vehicle_miles_reduced
      t.integer :three_month_trip_count
      t.integer :three_vehicle_miles_reduced
      t.integer :three_month_unreachable
      t.integer :three_month_trip_count
      t.integer :three_vehicle_miles_reduced
      t.integer :three_month_unreachable

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :trip_reasons do |t|
      t.string :name
      t.boolean :work_related

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :contacts do |t|
      t.integer :case_id
      t.integer :user_id
      t.timestamp :date_time
      t.string :method
      t.string :description 
      t.text :notes

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :assessments do |t|
      t.integer :case_id
      t.integer :user_id
      t.integer :survey_id

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :events do |t|
      t.integer :case_id
      t.integer :user_id
      t.timestamp :date_time
      t.integer :event_type_id
      t.integer :funding_source_id
      t.integer :duration_in_hours
      t.text :notes
      
      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :event_types do |t|
      t.string :name

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :funding_sources do |t|
      t.string :name

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :ethnicities do |t|
      t.string :name

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

    create_table :dispositions do |t|
      t.string :name

      t.datetime :created_at
      t.string :created_by
      t.datetime :updated_at
      t.string :updated_by
      t.integer :lock_version
    end

  end

  def self.down
  end
end
