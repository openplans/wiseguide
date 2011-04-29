class Outcome < ActiveRecord::Base
  belongs_to :case
  belongs_to :trip_reason
end
