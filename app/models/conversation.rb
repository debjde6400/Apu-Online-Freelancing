class Conversation < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: "Siteuser"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "Siteuser"

  has_many :messages
  validates_uniqueness_of :sender_id, scope: :recipient_id

  def Conversation.between(sender_id, recipient_id)
    where("(conversations.sender_id = ? AND conversations.recipient_id = ?) OR (conversations.sender_id = ? AND conversations.recipient_id = ?)", sender_id, recipient_id, recipient_id, sender_id).first
  end

  def Conversation.involving(siteuser_id)
    where("conversations.sender_id = ? OR conversations.recipient_id = ?", siteuser_id, siteuser_id)
  end

  def received_messages(user_id)
    self.messages.where.not(siteuser_id: user_id)
  end

  def unread_messages(user_id)
    self.received_messages(user_id).where(read_at: nil)
  end

  def read_unread_messages(user_id)
    self.unread_messages(user_id).each do |message|
      message.mark_as_read
    end
  end
end
