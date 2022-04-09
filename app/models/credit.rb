class Credit < ApplicationRecord
  include AmountValidation
  belongs_to :user
  belongs_to :payment_transaction, class_name: 'Transaction'
end
