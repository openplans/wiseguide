class Contact < ActiveRecord::Base
  belongs_to :kase
  belongs_to :user
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  validates :description, :presence => true, :length => {:maximum => 30}

  default_scope order(:date_time)

  def customer
    return kase.customer
  end

end
