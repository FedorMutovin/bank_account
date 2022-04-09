class Transaction < ApplicationRecord
  include AmountValidation
  has_many :credits, foreign_key: :payment_transaction_id, dependent: :destroy, inverse_of: :payment_transaction
  has_many :transfers, foreign_key: :payment_transaction_id, dependent: :destroy, inverse_of: :payment_transaction
  belongs_to :sender_account, class_name: 'Account'
  belongs_to :recipient_account, class_name: 'Account'

  validates :successful, :uuid, presence: true
  validates :uuid, uniqueness: { case_sensitive: false }
end
