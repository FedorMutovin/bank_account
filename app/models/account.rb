class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, foreign_key: :sender_account_id, dependent: :destroy, inverse_of: :sender_account
  has_many :transactions, foreign_key: :recipient_account_id, dependent: :destroy, inverse_of: :recipient_account

  validates :number, :balance, presence: true
  validates :number, uniqueness: { case_sensitive: false }
  validates :balance, numericality: { only_float: true, greater_than_or_equal_to: 0 }
end
