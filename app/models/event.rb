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
  validates_presence_of :date
  validates_presence_of :duration_in_hours

  default_scope order(:date)
  scope :in_range, lambda {|start_date, end_date| where(:date => start_date..end_date)}

  def customer
    return kase.customer
  end

  def start_time
    read_attribute(:start_time).try :to_s, :just_time
  end

  def end_time
    read_attribute(:end_time).try :to_s, :just_time
  end

end
