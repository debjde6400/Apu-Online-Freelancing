class Bid < ApplicationRecord
  belongs_to :bidding_user, class_name: 'Siteuser'
  belongs_to :project
  validates :bidding_user_id, uniqueness: { scope: :project_id }

  def award
    project = Project.find(project_id)
    project.update(awarded_freelancer_id: bidding_user_id)
    project.update(bidding_closed: true)
    BidAcceptedNotification.with(bid: self).deliver_later(bidding_user)

    Bid.where(project_id: self.project_id).not(id: self.id).each do |b|
      BidRejectedNotification.with(bid: b, accepted_bid: self).deliver_later(b.bidding_user)
    end
  end

end
