module AmountValidation
  extend ActiveSupport::Concern

  included do
    validates :amount, presence: true
    validates :amount, numericality: { only_float: true, greater_than: 0 }
  end
end
