class BidsController < ApplicationController
  before_action :get_bid_by_id, only: [:show, :edit, :update, :award, :correct_user, :check_client]
  before_action :get_project_by_params, only: [:has_any_bid, :index, :new, :create]
  before_action :has_any_bid, only: [:new, :create]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :get_project_by_bid, only: [:edit, :show, :award]
  before_action :check_client, only: [:award]

  def index
    @bids = @project.bids
  end

  def new
    @bid = @project.bids.new
  end

  def create
    @bid = @project.bids.new(bid_params)
    
    if @bid.save
      NewBidNotification.with(project: @project, bidder: @bid.bidding_user).deliver_later(@project.creating_client)
      redirect_to project_path(@project), flash: { success: "New bid created successfully." }
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
      redirect_to project_path(@bid.project), flash: { success: "Bid successfully updated." }
    else
      render 'edit'
    end
  end

  def destroy
    if current_user? @bid.bidding_user || current_user.admin?
      @bid.destroy
      redirect_to root_path, flash: { success: "Successfully removed your bid." } 
    else
      redirect_to root_path, flash: { danger: "This is not your bid." }
    end
  end

  def award
    if @project.awarded_freelancer.nil?
      @bid.award
      redirect_to @bid.project, flash: { success: "Bid successfully awarded." }
    else
      redirect_to @bid.project, flash: { warning: "You have already assigned the project to someone else." }
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
    redirect_to @project, flash: { warning: "You can bid for a project only once." } unless helpers.previous_bid(@project, current_user).empty?
  end

  def correct_user
    redirect_to(root_url, flash: { danger: "You cannot modify other's bids." }) unless current_user? @bid.bidding_user
  end

  def check_client
    redirect_to(root_url, flash: { danger: "A bid can only be awarded by the creator of the bidded project." }) unless current_user? @bid.project.creating_client
  end
end
