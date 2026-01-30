class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :chats, dependent: :destroy
  has_many :lists, dependent: :destroy
  has_many :company_lists, through: :lists
  has_many :companies, through: :company_lists

  # Validations
  validates :username, presence: true, length: { minimum: 2, maximum: 50 }
end
