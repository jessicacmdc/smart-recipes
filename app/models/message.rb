class Message < ApplicationRecord
  acts_as_message

  belongs_to :chat
  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }, if: -> { role == 'user' }
  scope :visible, -> { where(role: [:user, :assistant]).where.not(content: ["", nil]) }
end
