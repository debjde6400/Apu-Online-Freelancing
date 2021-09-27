class Siteadmin::SiteusersController < ApplicationController
  before_action :logged_in_user
  before_action :check_admin

  def index
    @users = Siteuser.all
  end

  def show
    @user = Siteuser.find(params[:id])
  end

  def approve
    @user = Siteuser.find(params[:id])
    @user.approve
    @user.send_activation_mail
    redirect_to siteadmin_siteuser_path(@user), flash: { notice: "User has been approved successfully." }
  end

  private

  def check_admin
    redirect_to root_path unless current_user.admin?
  end
end