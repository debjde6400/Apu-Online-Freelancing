class Siteuser < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save :downcase_email
  before_create :create_activation_digest
  has_one_attached :image
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
  format: { with: EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, allow_nil: true
  
  has_secure_password

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

  def displayed_image
    if image.attached?
      image
    else
      "3d-hd-wallpaper-radha-krishna-download.jpg"
    end
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
