class Transaction < ApplicationRecord
  include AmountValidation
  belongs_to :sender_account, class_name: 'Account'
  belongs_to :recipient_account, class_name: 'Account'

  validates :successful, presence: true
end
