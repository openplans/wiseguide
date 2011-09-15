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

  validates_presence_of :customer_id
  validates_presence_of :referral_type
  validates_presence_of :funding_source
  validates_presence_of :disposition

  scope :assigned_to, lambda {|user| where(:user_id => user.id) }
  scope :not_assigned_to, lambda {|user| where('user_id <> ?',user.id)}
  scope :unassigned, where(:user_id => nil)
  scope :open, where(:close_date => nil)
  scope :closed, where('close_date IS NOT NULL')

end
