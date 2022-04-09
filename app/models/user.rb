class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :trackable, :timeoutable
  has_one :account, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :transfers, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender
  has_many :transfers, foreign_key: :recipient_id, dependent: :destroy, inverse_of: :recipient

  def self.create_with_account(params)
    User.transaction do
      user_service = Users::CreateService.call(params)
      account_service = Accounts::CreateService.call(user: user_service.user)
      raise ActiveRecord::Rollback if user_service.failure? || account_service.failure?

      [user_service.user, account_service.account]
    end
  end

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
