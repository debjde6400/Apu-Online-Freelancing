class ProjectMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_mailer.notify_client.subject
  #

  def notify_new_bid
    @project = params[:project]
    @user = params[:bidder]
    mail to: @project.creating_client.email, subject: "New bid for project #{@project.title}"
  end

  def notify_about_delete
    @p_title = params[:project_title]
    @user = params[:bidder]
    mail to: @user.email, subject: "Removal of project #{@p_title}"
  end
end

