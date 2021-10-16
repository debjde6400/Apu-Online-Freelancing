class ProjectMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.project_mailer.notify_client.subject
  #

  def notify_client
    @project = params[:project]
    mail to: @project.creating_client.email, subject: "New bid for project #{@project.title}"
  end
end
