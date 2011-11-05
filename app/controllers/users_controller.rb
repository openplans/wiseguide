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
    authorize! :edit, User
    @user = User.new
  end

  def create_user
    authorize! :edit, User
    
    user_params = params[:user]
    user_params[:password] = user_params[:password_confirmation] = Devise.friendly_token[0..8]
    @user = User.new(user_params)
    @user.level = user_params[:level] #this should be unnecesary

    if @user.save
      NewUserMailer.new_user_email(@user, @user.password).deliver
      flash[:notice] = "%s has been added and a password has been emailed" % @user.email
      redirect_to users_path
    else
      render :action=>:new_user
    end
  end

  def update
    @user = User.find(params[:id])
    authorize! :edit, @user
    @user.level = params[:user][:level]
    @user.save
    redirect_to "/users"
  end

  def show_change_password
    @user = current_user
  end

  def change_password
    if current_user.update_password(params[:user])
      sign_in(current_user, :bypass => true)
      flash[:notice] = "Password changed"
      redirect_to users_path
    else
      flash.now[:alert] = "Error updating password"
      render :action=>:show_change_password
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
  
  def sign_out
    scope = Devise::Mapping.find_scope!(current_user)
    current_user = nil
    warden.logout(scope)

    return redirect_to "/"
  end

  def delete
    @user = User.find(params[:id])
    authorize! :manage, @user
    @user.level = -1
    @user.encrypted_password = "x"
    @user.save!
    redirect_to :users, :notice => "User #{@user.email} successfully marked deleted."
  end

end
