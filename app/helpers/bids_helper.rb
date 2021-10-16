module BidsHelper
  def previous_bid(project, user)
    Bid.where(project_id: project.id, bidding_user_id: user.id)
  end
end
