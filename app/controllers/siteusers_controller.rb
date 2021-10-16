class SiteusersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy]
  before_action :get_user_by_id, only: [:show, :edit, :update, :destroy, :posted_projects, :current_bids, :correct_user]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @users = Siteuser.all
  end

  def new
    @user = Siteuser.new
  end

  def create
    @user = Siteuser.new(siteuser_params)
    if @user.save
      redirect_to root_url, flash: { notice: "Joining request sent to admin. Once approved, an activation mail will be sent to you. Thanks." }
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(siteuser_params)
      redirect_to @user, flash: { success: "Profile successfully updated." }
    else
      render 'edit'
    end
  end

  def destroy
    if current_user? @user || current_user.admin?
      @user.destroy
      redirect_to root_path, notice: "Successfully removed account."
    else
      redirect_to root_path, danger: "You can delete your account only."
    end
  end

  def current_bids
    @current_bids = @user.bidding_user_bids.where(closed: false)
  end

  private
  
  def siteuser_params
    params.require(:siteuser).permit(:name, :email, :mobile, :address, :image, :freelancer, :qualification, :experience, :industry, :password, :password_confirmation, skills: [])
  end

  def correct_user
    redirect_to(root_url) unless current_user? @user
  end

  def get_user_by_id
    @user = Siteuser.find(params[:id])
  end
end