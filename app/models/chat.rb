class Chat < ApplicationRecord
  STATUSES = %w[pending processing completed failed].freeze

  # Associations
  belongs_to :user
  has_many :messages, dependent: :destroy
  accepts_nested_attributes_for :messages

  # Validations
  validates :status, presence: true, inclusion: { in: STATUSES }
end
