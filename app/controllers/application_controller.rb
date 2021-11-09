class ApplicationController < ActionController::Base
  include SessionsHelper
  
  def home
    render 'home/index'
  end

  def dashboard
    @current_bids = current_user.bidding_user_bids.joins(:project).includes([:project, :bidding_user]).where(project: {bidding_closed_at: nil}).page(params[:page1])
    if current_user.freelancer?
      @accepted_projects = Project.accepted_projects(current_user).page(params[:page])
    end
    render 'home/dashboard'
  end

  def remove_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to request.referrer
  end
  
  def read_notification
    notification = Notification.find(params[:notification_id])
    notification.mark_as_read!
    redirect_to notification.to_notification.url, flash: { success: "Attachment removed successfully." }
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_path, flash: { danger: "You MUST first Log in." }
    end
  end
end