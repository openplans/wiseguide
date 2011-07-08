class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  include Userstamp

  rescue_from CanCan::AccessDenied do |exception|
    render :file => "#{Rails.root}/public/403.html", :status => 403
  end
end
