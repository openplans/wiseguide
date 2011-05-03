class Customer < ActiveRecord::Base
  belongs_to :ethnicity
  has_many :customer_impairments
  has_many :impairments, :through => :customer_impairments
  has_many :kases
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'


  has_attached_file :portrait, :styles => { :small => "150x150>" }

  validates_attachment_size :portrait, :less_than => 300.kilobytes
  validates_attachment_content_type :portrait, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def name
    return "%s %s" % [first_name, last_name]
  end
end
