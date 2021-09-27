class ApplicationController < ActionController::Base
  include SessionsHelper
  
  def home
    render 'home/index'
  end

  private

  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url, flash: { danger: "You MUST first Log in." }
    end
  end
end