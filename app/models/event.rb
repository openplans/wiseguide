class Event < ActiveRecord::Base
  belongs_to :kase
  belongs_to :user
  belongs_to :event_type
  belongs_to :funding_source
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates_presence_of :kase_id
  validates_presence_of :event_type_id
  validates_presence_of :funding_source_id
  validates_presence_of :date_time

  def customer
    return kase.customer
  end

end
