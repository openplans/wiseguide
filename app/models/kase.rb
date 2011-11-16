class Kase < ActiveRecord::Base
  belongs_to :customer
  belongs_to :referral_type
  belongs_to :funding_source
  belongs_to :disposition
  belongs_to :assigned_to, :foreign_key=>:user_id, :class_name=>"User"

  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  has_many :contacts
  has_many :events
  has_many :response_sets
  has_many :kase_routes
  has_many :routes, :through=>:kase_routes
  has_many :outcomes

  VALID_COUNTIES = {'Clackamas' => 'C', 'Multnomah' => 'M', 'Washington' => 'W'}

  validates_presence_of :customer_id
  validates             :open_date, :date => { :before_or_equal_to => Proc.new { Date.today } }
  validates_presence_of :referral_source
  validates_presence_of :referral_type_id
  validates_presence_of :funding_source_id
  validates             :close_date, :date => { :after => :open_date, :before_or_equal_to => Proc.new { Date.today } }, :allow_blank => true
  validates_presence_of :disposition
  validates_presence_of :close_date, :if => Proc.new {|kase| kase.disposition.name != "In Progress" }
  validates_inclusion_of :county, :in => VALID_COUNTIES.values
  validate do |kase|
    kase.errors[:disposition_id] << "cannot be 'In Progress' if case is closed" if kase.close_date.present? && kase.disposition.name == 'In Progress'
  end

  scope :assigned_to, lambda {|user| where(:user_id => user.id) }
  scope :not_assigned_to, lambda {|user| where('user_id <> ?',user.id)}
  scope :unassigned, where(:user_id => nil)
  scope :open, where(:close_date => nil)
  scope :opened_in_range, lambda{|date_range| where(:open_date => date_range)}
  scope :open_in_range, lambda{|date_range| where("NOT (COALESCE(kases.close_date,?) < ? OR kases.open_date > ?)", date_range.begin, date_range.begin, date_range.end)}
  scope :closed, where('close_date IS NOT NULL')
  scope :closed_in_range, lambda{|date_range| where(:close_date => date_range)}
  scope :successful, where(:disposition_id => Disposition.successful.id)
  scope :has_three_month_follow_ups_due, successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id=kases.id AND (three_month_unreachable = true OR three_month_trip_count IS NOT NULL))', 3.months.ago + 1.week)
  scope :has_six_month_follow_ups_due, successful.where('kases.close_date < ? AND NOT EXISTS (SELECT id FROM outcomes WHERE kase_id = kases.id AND (six_month_unreachable = true OR six_month_trip_count IS NOT NULL))', 6.months.ago + 1.week)
  scope :for_funding_source_id, lambda {|funding_source_id| funding_source_id.present? ? where(:funding_source_id => funding_source_id) : where(true) }

end
