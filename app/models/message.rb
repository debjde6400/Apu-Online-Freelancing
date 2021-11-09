class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :siteuser
  validates_presence_of :body, :conversation_id, :siteuser_id
  
  def message_time
    created_at.strftime("%d/%m/%y at %l:%M %p")
  end

  def mark_as_read
    update_attribute(:read_at, Time.now)
  end
end
