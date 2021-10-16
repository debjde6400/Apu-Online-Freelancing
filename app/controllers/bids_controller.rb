class BidsController < ApplicationController
  before_action :get_bid_by_id, only: [:show, :edit, :update, :award, :get_correct_user_or_redirect]
  before_action :get_project_by_params, only: [:has_any_bid, :index, :new, :create]
  before_action :has_any_bid, only: [:new, :create]
  before_action :get_correct_user_or_redirect, only: [:edit, :update]
  before_action :get_project_by_bid, only: [:show, :award]

  def index
    @bids = @project.bids
  end

  def new
    @bid = @project.bids.new
  end

  def create
    @bid = @project.bids.new(bid_params)
    
    if @bid.save
      ProjectNotification.with(project: @project).deliver_later(@project.creating_client)
      redirect_to bid_path(@bid), flash: { success: "New bid created successfully." }
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @bid.update(bid_params)
      redirect_to bid_path(@bid), flash: { success: "Bid successfully updated." }
    else
      render 'edit'
    end
  end

  def award
    if @project.awarded_freelancer.nil?
      @bid.award
      redirect_to @bid.project, flash: { success: "Bid successfully awarded." }
    else
      redirect_to @bid, flash: { warning: "You have already assigned the project to someone else." }
    end
  end

  private

  def bid_params
    params.require(:bid).permit(:amount, :description, :bidding_user_id, :project_id)
  end

  def get_bid_by_id
    @bid = Bid.find(params[:id])
  end

  def get_project_by_params
    @project = Project.find(params[:project_id])
  end

  def get_project_by_bid
    @project = Project.find(@bid.project_id)
  end

  def has_any_bid
    unless helpers.previous_bid(@project, current_user).empty?
      flash[:danger] = "You can bid for a project only once."
      redirect_to @project
    end
  end

  def get_correct_user_or_redirect
    @user = helpers.correct_user(@bid.bidding_user)
    if @user.nil?
      flash[:danger] = "You cannot edit other's projects."
      redirect_to(root_url)
    else
      @user
    end
  end
end
