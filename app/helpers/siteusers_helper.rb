module SiteusersHelper
  def print_type(user)
    if user.freelancer?
      "Freelancer"
    else
      "Client"
    end
  end

  def display_else_na(detail)
    if detail && detail != ''
      detail
    else
      "N/A"
    end
  end
end