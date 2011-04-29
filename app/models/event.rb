class Event < ActiveRecord::Base
  belongs_to :case
  belongs_to :user
  belongs_to :event_type
  belongs_to :funding_source
end
