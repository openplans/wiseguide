class Case < ActiveRecord::Base
  belongs_to :customer
  belongs_to :referral_type
  belongs_to :funding_source
  belongs_to :disposition
  belongs_to :assigned_to, :foreign_key=>:user_id, :class_name=>"User"

  has_many :contacts
  has_many :events
  has_many :assessments
  has_many :case_routes
  has_many :routes, :through=>:case_routes
  has_many :outcomes

  validates_presence_of :customer_id
  validates_presence_of :referral_type
  validates_presence_of :funding_source
  validates_presence_of :disposition

end
