class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :trackable, :timeoutable
  has_one :account, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :sender_transfers,
           foreign_key: :sender_id,
           dependent: :destroy,
           inverse_of: :sender,
           class_name: 'Transfer'
  has_many :recipient_transfers,
           foreign_key: :recipient_id,
           dependent: :destroy,
           inverse_of: :recipient,
           class_name: 'Transfer'

  def self.create_with_account(params)
    User.transaction do
      user_service = Users::CreateService.call(params)
      account_service = Accounts::CreateService.call(user: user_service.user)
      raise ActiveRecord::Rollback if user_service.failure? || account_service.failure?

      [user_service.user, account_service.account]
    end
  end

  def transfers
    Transfer
      .includes(%i[recipient sender])
      .where('recipient_id = :id or sender_id = :id', { id: id })
      .order(created_at: :desc)
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
