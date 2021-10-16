class AddSkillsToSiteusersProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :siteusers, :skills, :text, array: true, default: []
    add_column :projects, :skills, :text, array: true, default: []
  end
end
