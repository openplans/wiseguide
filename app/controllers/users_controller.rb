class UsersController < Devise::SessionsController
  require 'new_user_mailer'
  
  def new
    #hooked up to sign_in
    if User.count == 0
      return redirect_to :action=>:show_init
    end
  end

  def new_user
    if User.count == 0
      return redirect_to :init
    end
    authorize! :edit, current_user.current_provider
    @user = User.new
  end

  def create_user
    authorize! :edit, current_user.current_provider
    
    @user = User.new(params[:user])
    @user.password = @user.password_confirmation = Devise.friendly_token[0..8]
    @user.current_provider_id = current_provider_id

    if @user.save
      NewUserMailer.new_user_email(@user, @user.password).deliver
      flash[:notice] = "%s has been added and a password has been emailed" % @user.email
      redirect_to users_path
    else
      render :action=>:new_user
    end
  end

  def show_init
    #create initial user
    if User.count > 0
      return redirect_to :action=>:new
    end
    @user = User.new
  end


  def init
    if User.count > 0
      return redirect_to :action=>:new
    end
    @user = User.new params[:user]
    @user.level = 100
    @user.save!

    flash[:notice] = "OK, now sign in"
    redirect_to :action=>:new
  end

end
