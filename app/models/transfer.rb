class Transfer < ApplicationRecord
  include AmountValidation
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
end
