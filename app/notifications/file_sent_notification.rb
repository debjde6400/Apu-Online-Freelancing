# To deliver this notification:
#
# FileSentNotification.with(post: @post).deliver_later(current_user)
# FileSentNotification.with(post: @post).deliver(current_user)

class FileSentNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "ProjectMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  param :project

  # Define helper methods to make rendering easier.
  #
  def message
    t(".message",  project_title: params[:project].title)
  end
  #
  def url
    freelancer_files_project_path(params[:project])
  end
end
