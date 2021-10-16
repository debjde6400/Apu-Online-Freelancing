module SiteusersHelper
  def print_type(user)
    if user.freelancer?
      "Freelancer"
    else
      "Client"
    end
  end
end