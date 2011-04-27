class AdminController < ApplicationController
  def users
    @users = User.all
  end
end
