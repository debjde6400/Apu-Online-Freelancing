# To deliver this notification:
#
# BidAcceptedNotification.with(post: @post).deliver_later(current_user)
# BidAcceptedNotification.with(post: @post).deliver(current_user)

class BidAcceptedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "BidMailer", method: :bid_acceptance
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :bid

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message", project_title: params[:bid].project.title)
  end
  
  def url
    project_path(params[:bid].project)
  end
end
