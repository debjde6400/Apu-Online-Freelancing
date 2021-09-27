class AccountactivationsController < ApplicationController
  def edit
    user = Siteuser.find_by(id: params[:id])
    if user && !user.activated?
      user.activate
      redirect_to login_path, flash: { success: "Account activated. Just login again." }
    else
      flash[:danger] = "Invalid activation link."
      redirect_to root_url
    end
  end
end
