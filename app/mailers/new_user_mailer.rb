class NewUserMailer < ActionMailer::Base
  default :from => EMAIL_FROM


  def new_user_email(user, password)
    @user = user
    @password = password
    @url = root_url
    mail(:to => user.email,  :subject => "Welcome to Wiseguide")
 end


end
