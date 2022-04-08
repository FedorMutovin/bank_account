class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :validatable, :trackable, :timeoutable
  has_one :account, dependent: :destroy
  has_many :credits, dependent: :destroy
  has_many :transfers, foreign_key: :sender_id, dependent: :destroy, inverse_of: :sender
  has_many :transfers, foreign_key: :recipient_id, dependent: :destroy, inverse_of: :recipient

  after_create :create_account, if: -> { account.nil? }

  private

  def create_account
    Accounts::CreateService.call(id)
  end
end
