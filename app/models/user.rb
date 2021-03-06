class User < ActiveRecord::Base
  model_stamper
  stampable :creator_attribute => :created_by_id, :updater_attribute => :updated_by_id
  belongs_to :created_by, :foreign_key => :created_by_id, :class_name=>'User'
  belongs_to :updated_by, :foreign_key => :updated_by_id, :class_name=>'User'

  has_many :surveys
  has_many :kases
  has_many :contacts
  has_many :events

  validates_confirmation_of :password
  validates_uniqueness_of :email
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  default_scope order(:email)
  scope :active, where("users.level >= 0")
  scope :active_or_selected, lambda{|user_id| where("users.level >= 0 OR users.id = ?",user_id)}

  def role_name
    case level
    when -1 
      return "Deleted"
    when 0
      return "Viewer"
    when 50
      return "Editor"
    when 100
      return "Admin"
    end
  end

  def is_admin
    return level == 100
  end

  def update_password(params)
    unless params[:password].blank?
      self.update_with_password(params)
    else
      self.errors.add('password', :blank)
      false
    end
  end
end
