class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :trackable, :timeoutable
  has_one :account, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :transfers, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender
  has_many :transfers, foreign_key: :recipient_id, dependent: :destroy, inverse_of: :recipient

  def get_credit(amount)
    credit_service = Credits::CreateService.call(
      user: self,
      amount: amount,
      account: account,
      bank_account: Account.bank_accounts.last
    )
    credit_service.success? ? credit_service.credit : credit_service.errors
  end
end
