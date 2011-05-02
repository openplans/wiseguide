class Customer < ActiveRecord::Base
  belongs_to :ethnicity
  has_many :customer_impairments
  has_many :impairments, :through => :customer_impairments
  has_many :cases

  has_attached_file :portrait, :styles => { :small => "150x150>" }

  validates_attachment_size :portrait, :less_than => 300.kilobytes
  validates_attachment_content_type :portrait, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def name
    return "%s %s" % [first_name, last_name]
  end
end
