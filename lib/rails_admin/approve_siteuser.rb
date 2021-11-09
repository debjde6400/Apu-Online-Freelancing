require 'rails_admin/config/actions/base'

module RailsAdmin
  class ApproveSiteuser < RailsAdmin::Config::Actions::Base    #Demo Operation inheritance Base
    RailsAdmin::Config::Actions.register(self)      #RailsAdmin Register in demo operation 

    register_instance_option :member? do
      true
    end
    
    register_instance_option :visible? do
      !bindings[:object].approved
    end

    register_instance_option :link_icon do
      'icon-check'
    end

    register_instance_option :controller do             # Set up action scope by member
      #@object = bindings[:object]
      Proc.new do
        @object.approve
        @object.send_activation_mail
        redirect_to request.referrer, flash: { info: "User has been approved successfully." }
      end
    end
  end
end