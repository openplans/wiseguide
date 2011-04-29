class Contact < ActiveRecord::Base
  belongs_to :case
  belongs_to :user


end
