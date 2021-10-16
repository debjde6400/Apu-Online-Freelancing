class Project < ApplicationRecord
  belongs_to :creating_client, class_name: 'Siteuser'
  belongs_to :awarded_freelancer, class_name: 'Siteuser', optional: true
  has_many :bids
  has_many_attached :client_files
  has_many_attached :freelancer_sent_files
  accepts_nested_attributes_for :client_files_attachments, allow_destroy: true
end
