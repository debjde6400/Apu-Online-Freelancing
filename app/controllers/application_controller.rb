class ApplicationController < ActionController::Base
  include SessionsHelper
  
  def home
    render 'home/index'
  end

  def dashboard
    render 'home/dashboard'
  end

  def remove_attachment
    attachment = ActiveStorage::Attachment.find(params[:id])
    attachment.purge
    redirect_to request.referrer
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, flash: { danger: "You MUST first Log in." }
    end
  end
end