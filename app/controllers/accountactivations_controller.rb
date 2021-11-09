class AccountactivationsController < ApplicationController
  def edit
    user = Siteuser.find_by(id: params[:id])
    if user && !user.activated?
      user.activate
      redirect_to root_path, flash: { success: "Account activated. Just login again." }
    else
      redirect_to root_path, flash: { danger: "Invalid activation link." }
    end
  end
end
