class Message < ApplicationRecord
  ROLES = %w[user assistant].freeze

  # Associations
  belongs_to :chat

  # Validations
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :content, presence: true
end
