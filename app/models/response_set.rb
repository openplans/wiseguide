class ResponseSet < ActiveRecord::Base
  include Surveyor::Models::ResponseSetMethods

  belongs_to :kase
  belongs_to :user

end
