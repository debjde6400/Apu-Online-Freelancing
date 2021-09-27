module ApplicationHelper
  def get_all_industry
    industry = File.read("#{Rails.root}/app/assets/textfiles/industry.txt").split("\n")
  end
end
