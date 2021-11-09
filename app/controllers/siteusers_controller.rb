class SiteusersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy, :check_client]
  before_action :get_user_by_id, only: [:show, :edit, :update, :destroy, :bid_history, :correct_user]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @users = Siteuser.industry_based_search(params[:searched_industries]).page(params[:page])
  end

  def new
    @user = Siteuser.new
  end

  def create
    @user = Siteuser.new(siteuser_params)

    if !@user.image.present?
      @user.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', '56939.jpg')), filename: '56939.jpg', content_type: 'image/jpg')
    end

    if @user.save
      redirect_to root_url, flash: { success: "Joining request sent to admin. Once approved, an activation mail will be sent to you. Thanks." }
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
      flash[:warning] = "Some error occurred. Check your edits."
      render 'edit'
    end
  end

  def destroy
    if current_user? @user || current_user.admin?
      @user.destroy
      redirect_to root_path, flash: { success: "Successfully removed account." }
    
    else
      redirect_to root_path, flash: { danger: "You can delete your account only." }
    end
  end

  def bid_history
    @bid_history = @user.bidding_user_bids.includes([:project, :bidding_user]).page(params[:page])
  end

  def search_freelancers
    @freelancers = Siteuser.skill_based_freelancer_search(params[:searched_skills])
  end

  private
  
  def siteuser_params
    params.require(:siteuser).permit(:name, :email, :mobile, :address, :image, :freelancer, :qualification, :experience, :industry, :password, :password_confirmation, skills: [], searched_industries: [], searched_skills: [])
  end

  def correct_user
    redirect_to(root_url, flash: { danger: "No editing of other's details." }) unless current_user? @user
  end

  def get_user_by_id
    @user = Siteuser.find(params[:id])
  end
end