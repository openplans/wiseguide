class User < ActiveRecord::Base
  has_many :assessments
  has_many :cases
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

  def role_name
    case level
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

end
