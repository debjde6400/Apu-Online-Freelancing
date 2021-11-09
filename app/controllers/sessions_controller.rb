class SessionsController < ApplicationController
  def new
  end

  def create
    user = Siteuser.find_by(email: params[:session][:email].downcase)
    
    if logged_in?
      redirect_to request.referrer, flash: { danger: "Login failed. Someone is already logged in this machine." }
    
    elsif user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        redirect_back_or((user.admin? ? rails_admin_path : dashboard_path), "success", "Successfully logged in.")
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)

      else
        flash[:warning] = "Account not activated. Check your email for the activation link."
        redirect_to root_url
      end
    
    else
      flash[:warning] = 'Invalid email / password combination'
      render "new"
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url,  flash: { success: "Logged out successfully." }
  end
end
