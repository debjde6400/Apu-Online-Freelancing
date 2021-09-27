# Preview all emails at http://localhost:3000/rails/mailers/siteuser_mailer
class SiteuserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/siteuser_mailer/account_activation
  def account_activation
    user = Siteuser.first
    user.activation_token = Siteuser.new_token
    SiteuserMailer.account_activation(user)
  end

  def password_reset
    user = Siteuser.first
    user.reset_token = Siteuser.new_token
    SiteuserMailer.password_reset(user)
  end

end
