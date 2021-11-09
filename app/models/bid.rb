class Bid < ApplicationRecord
  belongs_to :bidding_user, class_name: 'Siteuser'
  belongs_to :project
  validates :bidding_user_id, uniqueness: { scope: :project_id }
  has_noticed_notifications
  has_noticed_notifications param_name: "accepted_bid"

  def award
    project = Project.find(project_id)
    project.update(awarded_freelancer_id: bidding_user_id, bidding_closed: true, bidding_closed_at: Time.now)
    BidAcceptedNotification.with(bid: self).deliver_later(bidding_user)

    Bid.where("project_id = ? AND id != ?", self.project_id, self.id).each do |b|
      BidRejectedNotification.with(bid: b, accepted_bid: self).deliver_later(b.bidding_user)
    end
  end

  def closed?
    project = Project.find(project_id)
    project.bidding_closed?
  end

  def awarded?
    project = Project.find(project_id)
    self.bidding_user_id == project.awarded_freelancer_id
  end

  def status
    if !closed?
      "<span> Pending </span>".html_safe

    elsif !awarded?
      "<span class='text-danger'> Rejected </span>".html_safe
    
    else
      "<span class='text-success'> Accepted </span>".html_safe
    end
  end

end
