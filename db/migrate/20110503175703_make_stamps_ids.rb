class MakeStampsIds < ActiveRecord::Migration
  def self.up
    for table in ["assessments",
                  "contacts",
                  "customer_impairments",
                  "customers",
                  "dispositions",
                  "ethnicities",
                  "event_types",
                  "events",
                  "funding_sources",
                  "impairments",
                  "kase_routes",
                  "kases",
                  "outcomes",
                  "referral_types",
                  "routes",
                  "trip_reasons",
                  "users"]
      remove_column table, :created_by
      add_column table, :created_by_id, :integer
      if table != "kase_routes" && table != "customer_impairments" 
      remove_column table, :updated_by
      add_column table, :updated_by_id, :integer
      end
    end
  end

  def self.down
  end
end
