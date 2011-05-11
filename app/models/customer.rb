class Customer < ActiveRecord::Base
  belongs_to :ethnicity
  has_many :customer_impairments
  has_many :impairments, :through => :customer_impairments
  has_many :kases
  has_many :customer_support_network_members
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'


  has_attached_file :portrait, :styles => { :small => "150x150>" }

  validates_attachment_size :portrait, :less_than => 300.kilobytes
  validates_attachment_content_type :portrait, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  validates_presence_of :ethnicity_id

  def name
    return "%s %s" % [first_name, last_name]
  end

  def age_in_years
    if birth_date.nil?
      return nil
    end
    today = Date.today
    years = today.year - birth_date.year #2011 - 1980 = 31
    if today.month < birth_date.month  || today.month == birth_date.month and today.day < birth_date.day #but 4/8 is before 7/3, so age is 30
      years -= 1
    end
    return years
  end

end
