# To deliver this notification:
#
# ProjectNotification.with(post: @post).deliver_later(current_user)
# ProjectNotification.with(post: @post).deliver(current_user)

class NewBidNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "ProjectMailer", method: :notify_new_bid
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :project, :bidder

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message", project_title: params[:project].title, bidder_name: params[:bidder].name)
  end
  #
  def url
    project_path(params[:project])
  end
end
