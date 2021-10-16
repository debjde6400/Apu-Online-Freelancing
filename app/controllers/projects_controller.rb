class ProjectsController < ApplicationController
  before_action :get_project_by_id, only: [:show, :edit, :update, :get_correct_user_or_redirect, :freelancer_files, :send_files]
  before_action :get_user_by_params, only: [:index, :new, :create]
  before_action :get_correct_user_or_redirect, only: [:edit, :update]
  before_action :get_accessor_users_or_redirect, only: [:freelancer_files, :send_files]

  def index
    @projects = @user.creating_client_projects
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

  def all_projects
    @all_projects = Project.all
  end

  def freelancer_files
  end
  
  def send_files
    if @project.update(project_file_params)
      redirect_to @project, flash: { success: "Files have successfully been uploaded." }
    else
      flash[:warning] = "Something went wrong."
      render 'freelancer_files'
    end
  end

  private

  def project_params
    params.require(:project).permit(:title, :description, skills: [], client_files: [], client_files_attributes: [:id, :_destroy])
  end

  def get_correct_user_or_redirect
    @user = helpers.correct_user(@project.creating_client)
    if @user.nil?
      flash[:danger] = "You cannot edit other's projects."
      redirect_to(root_url)
    else
      @user
    end
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
      flash[:danger] = "File sharing can only be done by either the posting client or the freelancer who is awarded the project."
      redirect_to(root_url)
    end
  end
end
