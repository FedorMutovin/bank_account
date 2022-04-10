class Transfer < ApplicationRecord
  include AmountValidation

  ALLOWED_CATEGORIES = { credit: 'credit', transfer: 'internal_transfer' }.freeze

  has_one :credit, dependent: :destroy
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :payment_transaction, class_name: 'Transaction'

  validates :category, presence: true, inclusion: { in: ALLOWED_CATEGORIES.values }
end
