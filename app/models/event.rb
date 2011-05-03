class Event < ActiveRecord::Base
  belongs_to :kase
  belongs_to :user
  belongs_to :event_type
  belongs_to :funding_source
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

end
