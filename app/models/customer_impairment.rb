class CustomerImpairment < ActiveRecord::Base
  belongs_to :customer
  belongs_to :impairment
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'  
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates :impairment_id, :presence => true
  validates :notes, :length => {:maximum => 255}
end
