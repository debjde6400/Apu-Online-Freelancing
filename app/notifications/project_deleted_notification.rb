# To deliver this notification:
#
# ProjectDeletedNotification.with(post: @post).deliver_later(current_user)
# ProjectDeletedNotification.with(post: @post).deliver(current_user)

class ProjectDeletedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "ProjectMailer", method: :notify_about_delete
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :project_title, :bidder

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message", project_title: params[:project_title])
  end
  #
  def url
    bid_history_siteuser_path(params[:bidder])
  end
end
