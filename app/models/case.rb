class Case < ActiveRecord::Base
  belongs_to :customer
  belongs_to :referral_type
  belongs_to :funding_source
  belongs_to :disposition

end
