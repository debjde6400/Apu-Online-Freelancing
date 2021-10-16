module ApplicationHelper
  def get_all_industry
    industry = File.read("#{Rails.root}/app/assets/textfiles/industry.txt").split("\n")
  end
  
  def get_all_skill
    skill = File.read("#{Rails.root}/app/assets/textfiles/skill.txt").split("\n")
  end

  def correct_user(user)
    user = Siteuser.find(user.id)
    if current_user? user || current_user.admin?
      return user
    else
      return nil
    end
  end

  def get_user_by_siteuser_id(id)
    Siteuser.find(id)
  end
end
