module ProjectsHelper
  def project_rate(project)
    if project.highest_pay.to_f > 0.0
      return "<span><strong> #{project.payment_currency} #{project.highest_pay} </strong></span> <span> &nbsp; #{project.payment_time_unit} </span>".html_safe
    else
      return "Unspecified"
    end
  end

  def bid_heading(project)
    if !current_user || (current_user.client? && !project.bidding_closed?)
      "Project Bids"
    else
      "Other Bids"
    end
  end
end
