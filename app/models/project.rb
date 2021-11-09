class Project < ApplicationRecord
  belongs_to :creating_client, class_name: 'Siteuser'
  belongs_to :awarded_freelancer, class_name: 'Siteuser', optional: true
  has_many :bids, dependent: :destroy
  has_many_attached :client_files
  has_many_attached :freelancer_sent_files
  validates :highest_pay, presence: true
  accepts_nested_attributes_for :client_files_attachments, allow_destroy: true
  scope :accepted_projects, ->(siteuser) { where(awarded_freelancer_id: siteuser.id) }
  has_noticed_notifications

  def freelancer_awarded?
    awarded_freelancer.nil?
  end

  def status
    if freelancer_awarded?
      "<span class='text-success'> Bidding open </span>".html_safe
    else
      "<span class='text-danger'> Bidding closed </span>".html_safe
    end
  end

  def notify_bidders_about_deletion
    p_title = self.title
    bids = self.bids
    bids.each do |b|
      bidder = b.bidding_user
      ProjectDeletedNotification.with(project_title: p_title, bidder: bidder).deliver_later(bidder)
    end
  end
end
