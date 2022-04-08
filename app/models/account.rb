class Account < ApplicationRecord
  belongs_to :user

  validates :number, :balance, presence: true
  validates :number, uniqueness: { case_sensitive: false }
  validates :balance, numericality: { only_float: true, greater_than_or_equal_to: 0 }
end
