class Credit < ApplicationRecord
  include AmountValidation
  belongs_to :user
end
