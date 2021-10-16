# To deliver this notification:
#
# BidRejectedNotification.with(post: @post).deliver_later(current_user)
# BidRejectedNotification.with(post: @post).deliver(current_user)

class BidRejectedNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  deliver_by :email, mailer: "BidMailer", method: :bid_rejection
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :bid, :accepted_bid

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message", project_title: params[:bid].project.title)
  end
  
  def url
    bid_path(params[:bid])
  end
end
