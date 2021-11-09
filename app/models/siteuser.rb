class Siteuser < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  has_one_attached :profile_pic

  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
  format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  
  validates :password, presence: true, allow_nil: true
  has_secure_password
  scope :freelancers, -> { where freelancer: true }
  scope :clients, -> { where freelancer: false }
  scope :active, -> { where(approved: true, activated: true) }
  has_many :creating_client_projects, class_name: 'Project', foreign_key: 'creating_client_id', dependent: :destroy
  has_many :awarded_freelancer_projects, class_name: 'Project', foreign_key: 'awarded_freelancer_id'
  has_many :bidding_user_bids, class_name: 'Bid', foreign_key: 'bidding_user_id', dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_noticed_notifications
  has_noticed_notifications param_name: "bidder"

  def client?
    !self.freelancer?
  end

  def Siteuser.industry_based_search(searched_industries)
    if searched_industries
      Siteuser.active.where(industry: searched_industries)
    else
      Siteuser.active
    end
  end

  def Siteuser.skill_based_freelancer_search(searched_skills)
    if searched_skills
      Siteuser.freelancers.active.select { |u| u.skills & searched_skills != [] }
    else
      Siteuser.freelancers.active
    end
  end

  def Siteuser.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def Siteuser.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = Siteuser.new_token
    update_attribute(:remember_digest, Siteuser.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def approve
    update_attribute(:approved, true)
  end

  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  def send_activation_mail
    SiteuserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = Siteuser.new_token
    update_attribute(:reset_digest,  Siteuser.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def send_password_reset_email
    SiteuserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def has_unread_messages?
    conversations = Conversation.involving(id).eager_load(:messages)

    conversations.each do |c| 
      if c.unread_messages(self.id).present?
        return true
      end
    end
    
    return false
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def create_activation_digest
    self.activation_token = Siteuser.new_token
    self.activation_digest = Siteuser.digest(activation_token)
  end
end
