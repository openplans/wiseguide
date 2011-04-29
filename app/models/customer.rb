class Customer < ActiveRecord::Base
  belongs_to :ethnicity
  has_many :customer_impairments
  has_many :impairments, :through => :customer_impairments
  has_many :cases

  has_attached_file :portrait, :styles => { :small => "150x150>" }
end
