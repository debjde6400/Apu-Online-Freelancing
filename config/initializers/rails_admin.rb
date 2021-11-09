RailsAdmin.config do |config|

  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.parent_controller = "::ApplicationController"

  config.authorize_with do
    redirect_to main_app.root_path, flash: { danger: "You are not an admin. How can you access the admin panel?" } unless current_user.admin?
  end

  require 'rails_admin/approve_siteuser'

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    #collection
    new
    export
    bulk_delete
    #member
    show
    edit
    delete
    show_in_app
    approve_siteuser do
      only 'Siteuser'
    end

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
