class Transfer < ApplicationRecord
  include AmountValidation
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :payment_transaction, class_name: 'Transaction'
end
