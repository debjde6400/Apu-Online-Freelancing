class PasswordresetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = Siteuser.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      redirect_to root_url, flash: { info: "Email sent with password reset instructions." }
      
    else
      flash[:danger] = "Email address not found."
      render 'new'
    end
  end

  def update
    if params[:siteuser][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    
    elsif @user.update(user_params)
      redirect_to root_path, flash: { success: "Password has been reset." }
    
    else
      render 'edit'
    end
  end

  def edit
  end

  private

  def user_params
    params.require(:siteuser).permit(:password, :password_confirmation)
  end

  def get_user
    @user = Siteuser.find_by(email: params[:email])
  end

  def valid_user
    unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
      redirect_to root_url
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset expired."
      redirect_to new_passwordreset_url
    end
  end
end