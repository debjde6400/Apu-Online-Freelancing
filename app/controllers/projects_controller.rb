class ProjectsController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :destroy, :freelancer_files, :send_files]
  before_action :get_project_by_id, only: [:show, :edit, :update, :correct_user, :destroy, :freelancer_files, :send_files]
  before_action :get_user_by_params, only: [:index, :new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :get_accessor_users_or_redirect, only: [:freelancer_files, :send_files]

  def index
    @projects = @user.creating_client_projects.page(params[:page])
  end

  def new
    @project = @user.creating_client_projects.new
  end

  def create
    @project = @user.creating_client_projects.new(project_params)

    if @project.save
      redirect_to @project, flash: { success: "New project created successfully." }
    else
      render 'new'
    end
  end

  def show
    if logged_in? && current_user.freelancer?
      @user_bid = helpers.previous_bid(@project, current_user)
      @bids = @project.bids.where.not(bidding_user_id: current_user.id).includes([:bidding_user]).page(params[:page])
    
    else
      @bids = @project.bids.includes([:bidding_user]).page(params[:page])
    end

    if !@project.awarded_freelancer.nil?
      @awarded_bid = helpers.previous_bid(@project, @project.awarded_freelancer)
      @bids = @bids.where.not(bidding_user_id: @project.awarded_freelancer.id)
    end
  end

  def edit
  end
  
  def update
    if @project.update(project_params)
      redirect_to @project, flash: { success: "Project successfully updated." }
    else
      render 'edit'
    end
  end

  def destroy
    if current_user? @project.creating_client || current_user.admin?
      @project.notify_bidders_about_deletion
      @project.destroy
      redirect_to root_path, flash: { success: "Successfully removed project." }

    else
      redirect_to root_path, flash: { danger: "You have not created the project and therefore cannot delete it." }
    end
  end

  def all_projects
    @all_projects = Project.all.includes([:awarded_freelancer]).page(params[:page])
  end

  def freelancer_files
  end
  
  def send_files
    if @project.update(project_file_params)
      FileSentNotification.with(project: @project).deliver_later(@project.creating_client)
      redirect_to @project, flash: { success: "Files have successfully been uploaded." }
    else
      flash[:warning] = "Something went wrong."
      render 'freelancer_files'
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, :highest_pay, :payment_time_unit, :payment_currency, skills: [], client_files: [], freelancer_sent_files: [], client_files_attributes: [:id, :_destroy])
  end

  def correct_user
    redirect_to(root_url, flash: { danger: "You cannot modify other's projects." }) unless current_user? @project.creating_client
  end

  def get_project_by_id
    @project = Project.find(params[:id])
  end

  def get_user_by_params
    @user = helpers.get_user_by_siteuser_id(params[:siteuser_id])
  end

  def project_file_params
    params.require(:project).permit(freelancer_sent_files: [])
  end

  def get_accessor_users_or_redirect
    @user = helpers.correct_user(@project.awarded_freelancer) || helpers.correct_user(@project.creating_client)

    if @user.nil?
      redirect_to root_url, flash: { danger: "File sharing can only be done by either the posting client or the freelancer who is awarded the project." }
    end
  end
end
