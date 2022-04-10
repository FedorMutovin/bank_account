class Credit < ApplicationRecord
  include AmountValidation
  belongs_to :user
  belongs_to :transfer
end
