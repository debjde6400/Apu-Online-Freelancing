class BidMailer < ApplicationMailer
  def bid_acceptance
    @bid = params[:bid]
    mail to: @bid.bidding_user.email, subject: "Bid acceptance email"
  end
  
  def bid_rejection
    @accepted = params[:accepted_bid]
    @bid = params[:bid]
    mail to: @bid.bidding_user.email, subject: "Bid rejection email"
  end
end
